class Visit < ActiveRecord::Base
  belongs_to :site
  belongs_to :page
  belongs_to :browser
  belongs_to :platform
  serialize :plugins
  attr_accessible :visitor_id

  validates :site_id, :visitor_id, :timestamp, presence: true
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

  def screen_size
    "#{screen_width}x#{screen_height}"
  end

  def browser_inner_size
    "#{browser_inner_width}x#{browser_inner_height}"
  end

  after_create :increment_site_stats
  def increment_site_stats
    site.increment_hits(unique?)
  end

  after_create do
    ExpandVisitWorker.perform_async(id)
  end
  
  def expand!
    find_or_create_page
    find_or_create_browser
    find_or_create_platform
  end

  def find_or_create_page
    self.page = site.pages.find_or_create_by_path(uri.path)
    page.name = title if page.name.blank?
    save
    increment_page_stats
    page
  end

  def increment_page_stats
    page.increment_hits(unique_for_page?)
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

  # Is this a unique visit for the associated page?
  # Only used on creation
  #
  # @return [true, false]
  def unique_for_page?
    unique = case
    when page.visitor_ids.include?(visitor_id)
      false
    when page.recent_visitor?(visitor_id)
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
  
  # Create a visit record from client-gathered data
  #
  # @return [Visit] the created visit
  def self.create_from_client_data(data = {})
    site = Site.find_by_api_key(data[:api_key])
    raise InvalidAPIKey if site.nil?

    site.visits.create! do |v|
      v.timestamp = Time.at(data[:timestamp].to_f)
      v.ip_address = data[:ip_address]
      v.visitor_id = data[:visitor_id]
      v.previous_visit = Time.at(data[:previous_visit].to_f) unless data[:previous_visit].blank?
      v.previous_page = data[:previous_page]
      v.user_agent = data[:browser][:user_agent]
      v.cookies_enabled = data[:browser][:cookies_enabled]
      v.java_enabled = data[:browser][:java_enabled]
      v.plugins = data[:browser][:plugins]
      v.screen_height = data[:system][:screen][:height]
      v.screen_width = data[:system][:screen][:width]
      v.screen_colour_depth = data[:system][:screen][:colour_depth]
      v.screen_available_height = data[:system][:screen][:available_height]
      v.screen_available_width = data[:system][:screen][:available_width]
      v.browser_inner_height = data[:browser][:inner_height]
      v.browser_inner_width = data[:browser][:inner_width]
      v.url = data[:page][:url]
      v.referrer = data[:page][:referrer]
      v.title = data[:page][:title]
      v.last_modified = data[:page][:last_modified]
    end
  end

  class InvalidAPIKey < StandardError; end
end
