class Site < ActiveRecord::Base
  include Redis::Objects

  belongs_to :user
  has_many :visits
  has_many :pages

  list :visitor_ids
  list :visitor_ips
  counter :hits
  counter :unique_hits

  attr_accessible :api_key, :name, :user_id, :allowed_hosts

  def populate_redis_lists
    visits.find_each do |visit|
      visitor_ids << visit.visitor_id unless visitor_ids.include?(visit.visitor_id)
      visitor_ips << visit.ip_address.to_s unless visitor_ips.include?(visit.ip_address.to_s)
    end
  end
  
  def pusher_channel
    "private-site-#{id}"
  end

  def push
    begin
      site = SiteDecorator.new(self)
      json = Rabl::Renderer.json(site, "sites/show")
      Pusher.trigger(pusher_channel, "updated", json)
    rescue Pusher::Error => ex
      #TODO: Figure out what to do with errors
    end
  end
end
