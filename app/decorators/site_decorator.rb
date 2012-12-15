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
end
