class Page < ActiveRecord::Base
  include Redis::Objects
  define_callbacks :counters_updated

  belongs_to :site
  has_many :visits

  counter :hits
  counter :unique_hits

  attr_accessible :path, :site_id

  validates :site_id, :path, presence: true

  after_create { push("created") }
  set_callback :counters_updated, :after, :push

  def visitor_ids
    @visitor_ids ||= Rails.cache.fetch("pages/#{id}/visitor_ids", expires_in: 10.minutes) do
      ids = []
      visits.find_in_batches do |visits|
        ids.concat visits.map(&:visitor_id)
      end

      ids.uniq
    end
  end

  # Used to compensate for the lag in +visitor_ids+
  # Should only be read if nothing found in +visitor_ids+
  #
  # @returns [true, false] as to whether user visited in the last 10 minutes
  def recent_visitor?(visitor_id)
    recent = Rails.cache.read("pages/#{id}/recent_visitor?visitor_id=#{visitor_id}")
    if !recent
      Rails.cache.write("pages/#{id}/recent_visitor?visitor_id=#{visitor_id}", true, expires_in: 10.minutes)
    end

    !!recent
  end

  def increment_hits(unique = false)
    run_callbacks :counters_updated do
      hits.increment
      if unique
        unique_hits.increment
      end
    end
  end

  def push(event = "updated")
    begin
      page = PageDecorator.new(self)
      json = Rabl::Renderer.json(page, "pages/show")
      Pusher.trigger(account.pusher_channel, event, json)
    rescue Pusher::Error => ex
      #TODO: Figure out what to do with errors
    end
  end
end
