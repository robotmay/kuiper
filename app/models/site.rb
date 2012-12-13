class Site < ActiveRecord::Base
  include Redis::Objects
  define_callbacks :counters_updated

  belongs_to :user
  has_many :visits
  has_many :pages

  counter :hits
  counter :unique_hits

  attr_accessible :api_key, :name, :user_id, :allowed_hosts

  validates :user_id, :name, :api_key, presence: true

  before_validation :generate_api_key, on: :create
  after_create { push("created") }
  set_callback :counters_updated, :after, :push

  def visitor_ids
    @visitor_ids ||= Rails.cache.fetch("sites/#{id}/visitor_ids", expires_in: 10.minutes) do
      ids = []
      visits.find_in_batches do |visits|
        ids.concat visits.map(&:visitor_id)
      end

      ids.uniq
    end
  end

  def visitor_ips
    @visitor_ips ||= Rails.cache.fetch("sites/#{id}/visitor_ips", expires_in: 10.minutes) do
      ips = []
      visits.find_in_batches do |visits|
        ids.concat visits.map(&:ip_address)
      end

      ips.uniq
    end
  end

  def increment_hits(unique = false)
    run_callbacks :counters_updated do
      hits.increment
      if unique
        unique_hits.increment
      end
    end
  end
  
  def pusher_channel
    "private-site-#{id}"
  end

  def push(event = "updated")
    begin
      site = SiteDecorator.new(self)
      json = Rabl::Renderer.json(site, "sites/show")
      Pusher.trigger(pusher_channel, event, json)
    rescue Pusher::Error => ex
      #TODO: Figure out what to do with errors
    end
  end

  private
  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
