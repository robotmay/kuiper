class Page < ActiveRecord::Base
  include Redis::Objects

  belongs_to :site
  has_many :visits

  list :visitor_ids
  counter :hits
  counter :unique_hits

  attr_accessible :path, :site_id

  validates :site_id, :path, presence: true

  def pusher_channel
    "private-page-#{id}"
  end

  def push
    begin
      page = PageDecorator.new(self)
      json = Rabl::Renderer.json(page, "pages/show")
      Pusher.trigger(pusher_channel, "updated", json)
    rescue Pusher::Error => ex
      #TODO: Figure out what to do with errors
    end
  end
end
