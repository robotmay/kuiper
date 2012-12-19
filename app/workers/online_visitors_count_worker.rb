class OnlineVisitorsCountWorker
  include Sidekiq::Worker
  sidekiq_options queue: :medium

  def perform(site_id)
    site = Site.find(site_id)
    site.log_current_online_visitors_count
    OnlineVisitorsCountWorker.perform_in(1.minutes, site_id)
  end
end
