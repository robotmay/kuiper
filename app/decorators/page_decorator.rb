class PageDecorator < Draper::Decorator
  delegate_all
  decorates_association :site
  decorates_association :visits

  def hits
    source.hits.value
  end

  def unique_hits
    source.unique_hits.value
  end
end
