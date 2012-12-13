class Visit < ActiveRecord::Base
  belongs_to :site
  belongs_to :page
  belongs_to :browser
  belongs_to :platform
  serialize :plugins
  attr_accessible :visitor_id

  validates :site_id, presence: true
  validate :host_allowed?

  def host_allowed?
    unless site.allowed_hosts.include?(uri.host)
      errors.add(:url, "URL does not match allowed hosts")
    end
  end

  def user_agent
    AgentOrange::UserAgent.new(super)
  end

  def uri
    URI::parse(url)
  end

  after_create :increment_site_visits
  def increment_site_visits
    site.visits.increment
    if unique?
      site.unique_visits.increment
    end
    
    add_to_site_lists
  end

  def add_to_site_lists
    site.visitor_ids << visitor_id unless site.visitor_ids.include?(visitor_id)
    site.visitor_ips << ip_address unless site.visitor_ips.include?(ip_address)
  end

  after_create do
    ExpandVisitWorker.perform_async(id)
  end

  def find_or_create_page
    self.page = site.pages.find_or_create_by_path(uri.path)
    save
    increment_page_stats
    page
  end

  def increment_page_stats
    page.visits.increment
    if unique_for_page?
      page.unique_visits.increment
    end
  end

  def find_or_create_browser
    self.browser = Browser.find_or_create_from_user_agent(user_agent)
    save
    increment_browser_stats
    browser
  end

  def increment_browser_stats
    browser.users.increment
    browser.parent.users.increment
    browser.users_for_site(site.id).increment
  end

  def find_or_create_platform
    self.platform = Platform.find_or_create_from_user_agent(user_agent)
    save
    increment_platform_stats
    platform
  end

  def increment_platform_stats
    platform.users.increment
    platform.parent.users.increment
    browser.users_for_site(site.id).increment
  end

  # Is this a unique visit?
  # Used only on creation to trigger unique counters
  #
  # @return [true, false]
  def unique?
    unique = case
    when previous_visit.present?
      false
    when site.visitor_ids.include?(visitor_id)
      false
    #TODO: More advanced unique testing
    #when site.visitor_ips.include?(ip_address)
      # Check for other matching data
    else
      true
    end 
  end

  def unique_for_page?
    unique = case
    when page.visitor_ids.include?(visitor_id)
      false
    else
      true
    end
  end

  # Finds the previous visit in this session
  #
  # @return [Visit] the previous visit
  def previous
    site.visits.order("timestamp ASC").where(timestamp: previous_visit, visitor_id: visitor_id).last
  end

  # Finds the next visit in this session
  #
  # @return [Visit] the next visit
  def next
    site.visits.order("timestamp ASC").where(previous_visit: timestamp, visitor_id: visitor_id).first
  end
  
  def self.create_from_client_data(data = {})
    site = Site.find_by_api_key(data[:api_key])
    raise InvalidAPIKey if site.nil?

    site.visits.create! do |v|
      v.timestamp = Time.at(data[:timestamp])
      v.ip_address = data[:ip_address]
      v.visitor_id = data[:visitor_id]
      v.previous_visit = Time.at(data[:previous_visit])
      v.previous_page = data[:previous_page]
      v.user_agent = data[:browser][:user_agent]
      v.platform = data[:browser][:platform]
      v.cookies_enabled = data[:browser][:cookies_enabled]
      v.java_enabled = data[:browser][:java_enabled]
      v.plugins = data[:browser][:plugins]
      v.screen_height = data[:system][:screen][:height]
      v.screen_width = data[:system][:screen][:width]
      v.screen_colour_depth = data[:system][:screen][:colour_depth]
      v.screen_available_height = data[:system][:screen][:available_height]
      v.screen_available_width = data[:system][:screen][:available_width]
      v.url = data[:page][:url]
      v.referrer = data[:page][:referrer]
      v.title = data[:page][:title]
      v.last_modified = data[:page][:last_modified]
    end
  end

  class InvalidAPIKey < StandardError; end
end
