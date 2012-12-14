class OnlineVisitorsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :medium 

  def perform(visit_id)
    visit = Visit.find(visit_id)
    timestamp = visit.timestamp.to_i.to_s

    last_seen = visit.site.online_visitors[visit.visitor_id]
    if last_seen.present? && last_seen == timestamp
      binding.pry
      visit.site.online_visitors.delete(visit.visitor_id)
    else
      visit.site.online_visitors[visit.visitor_id] = timestamp
      OnlineVisitorsWorker.perform_in(5.minutes, visit.id)
    end
  end
end
