class ExpandVisitWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform(visit_id)
    visit = Visit.find(visit_id)
    visit.find_or_create_page
    visit.find_or_create_browser
    visit.find_or_create_platform
  end
end
