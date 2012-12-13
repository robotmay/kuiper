class PageDecorator < Draper::Base
  decorates :page

  def hits
    page.hits.value
  end

  def unique_hits
    page.unique_hits.value
  end
end
