class OnlineVisitorsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :medium 

  def perform(visit_id)
    visit = Visit.find(visit_id)
    visit.site.remove_from_online_visitors(visit_id)
  end
end
