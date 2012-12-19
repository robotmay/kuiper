class SiteDecorator < Draper::Base
  decorates :site
  denies :visitor_ids, :visitor_ips

  def hits
    site.hits.value
  end

  def unique_hits
    site.unique_hits.value
  end

  def online_visitors
    site.online_visitors.count
  end

  def online_visitor_counts(date = Date.today)
    site.online_visitor_counts.for_date(date).order("created_at ASC").map do |ovc|
      { created_at: ovc.created_at.to_i, count: ovc.count }
    end
  end

  def recent_visits
    visits = site.visits.order("timestamp DESC").limit(10)
    visits.map { |v| VisitDecorator.new(v) }
  end
end
