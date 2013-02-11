class Site < ActiveRecord::Base
  include Redis::Objects
  define_callbacks :counters_updated

  belongs_to :account
  has_many :visits
  has_many :pages
  has_many :online_visitor_counts

  counter :hits
  counter :unique_hits
  hash_key :online_visitors

  attr_accessible :api_key, :name, :allowed_hosts

  validates :account_id, :name, :api_key, presence: true

  before_validation :generate_api_key, on: :create
  set_callback :counters_updated, :after, lambda {
    notify_observers(:after_counter_update)
  }

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

  def add_to_online_visitors(visit_id)
    visit = Visit.find(visit_id)
    timestamp = visit.timestamp.to_i.to_s

    unless online_visitors.keys.include?(visit.visitor_id)
      run_callbacks :counters_updated do
        online_visitors[visit.visitor_id] = timestamp
        OnlineVisitorsWorker.perform_in(1.minute, visit.id)
      end
    end
  end

  def remove_from_online_visitors(visit_id)
    visit = Visit.find(visit_id)
    timestamp = visit.timestamp.to_i.to_s
    last_seen = online_visitors[visit.visitor_id]

    if last_seen == timestamp
      run_callbacks :counters_updated do
        online_visitors.delete(visit.visitor_id)
      end
    else
      #TODO: Allow this to be configured per site
      OnlineVisitorsWorker.perform_in(1.minute, visit.id)
    end
  end

  def log_current_online_visitors_count
    online_visitor_counts.create(count: online_visitors.count)
  end

  def pusher_channel
    "#{account.pusher_channel}-sites"
  end

  private
  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
