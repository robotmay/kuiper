class SiteDecorator < Draper::Base
  decorates :site

  def hits
    site.hits.value
  end

  def unique_hits
    site.unique_hits.value
  end
end
