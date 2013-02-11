class VisitDecorator < Draper::Decorator
  delegate_all
  decorates_association :site
  decorates_association :page

  def browser
    source.browser.name
  end

  def platform
    source.platform.name
  end

  def path
    source.uri.path
  end
end
