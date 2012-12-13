class Page < ActiveRecord::Base
  include Redis::Objects

  belongs_to :site
  has_many :visits

  list :visitor_ids
  counter :visits
  counter :unique_visits

  attr_accessible :path, :site_id

  validates :site_id, :path, presence: true
end
