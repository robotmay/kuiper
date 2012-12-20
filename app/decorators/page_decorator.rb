class PageDecorator < Draper::Base
  decorates :page
  allows :name, :path, :hits, :unique_hits

  def hits
    page.hits.value
  end

  def unique_hits
    page.unique_hits.value
  end
end
