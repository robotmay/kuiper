class VisitDecorator < Draper::Base
  decorates :visit
  allows :site_id, :browser, :platform

  def browser
    visit.browser.name
  end

  def platform
    visit.platform.name
  end
end
