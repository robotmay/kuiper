class ExpandVisitWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform(visit_id)
    visit = Visit.find(visit_id)
    visit.expand!
  end
end
