class OnlineVisitorCount < ActiveRecord::Base
  belongs_to :site
  attr_accessible :count, :site_id

  scope :for_date, lambda { |date|
    where("created_at >= :start AND created_at <= :end", start: date.to_time.beginning_of_day, end: date.to_time.end_of_day)
  }
end
