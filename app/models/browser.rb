class Browser < ActiveRecord::Base
  include Redis::Objects
  acts_as_nested_set
  
  counter :users

  attr_accessible :name

  def users_for_site(site_id)
    Redis::Counter.new("#{redis_field_key(:users_for_site)}:#{site_id}")
  end

  def self.find_or_create_from_user_agent(user_agent)
    ua_browser = user_agent.device.engine.browser
    browser = find_or_create_by_name(ua_browser.name)
    version = browser.children.find_or_create_by_name([ua_browser.name, ua_browser.version].join(" "))
    return version
  end
end
