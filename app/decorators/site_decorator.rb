class SiteDecorator < Draper::Decorator
  delegate_all #TODO: Make this more restrictive
  decorates_association :pages
  decorates_association :visits

  def hits
    source.hits.value
  end

  def unique_hits
    source.unique_hits.value
  end

  def online_visitors
    source.online_visitors.count
  end

  def online_visitor_counts(date = Date.today)
    source.online_visitor_counts.for_date(date).order("created_at ASC").map do |ovc|
      { created_at: ovc.created_at.to_i, count: ovc.count }
    end
  end

  def recent_visits
    visits = source.visits.order("timestamp DESC").limit(10)
    visits.map { |v| VisitDecorator.new(v) }
  end
end
