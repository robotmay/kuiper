class VisitDecorator < Draper::Base
  decorates :visit
  decorates_association :page
  allows :id, :timestamp, :site_id, :url, :path, :browser, :platform, :screen_size, :browser_inner_size

  def browser
    visit.browser.name
  end

  def platform
    visit.platform.name
  end

  def path
    visit.uri.path
  end
end
