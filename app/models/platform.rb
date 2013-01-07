class Platform < ActiveRecord::Base
  include Redis::Objects
  acts_as_nested_set
  
  counter :users

  attr_accessible :name

  def users_for_site(site_id)
    Redis::Counter.new("platforms:#{id}:users_for_site:#{site_id}")
  end

  def self.find_or_create_from_user_agent(user_agent)
    ua_platform = user_agent.device.operating_system
    platform = find_or_create_by_name(ua_platform.name)
    name = [ua_platform.name, ua_platform.version].join(" ")
    version = platform.children.find_by_name(name) || platform.children.create do |p|
      p.name = name
      p.short_name = ua_platform.type
    end
    return version
  end
end
