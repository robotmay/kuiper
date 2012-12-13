class Page < ActiveRecord::Base
  include Redis::Objects

  belongs_to :site
  has_many :visits

  list :visitor_ids
  counter :hits
  counter :unique_hits

  attr_accessible :path, :site_id

  validates :site_id, :path, presence: true

  after_create { push("created") }

  def pusher_channel
    "private-page-#{id}"
  end

  def push(event = "updated")
    begin
      page = PageDecorator.new(self)
      json = Rabl::Renderer.json(page, "pages/show")
      Pusher.trigger(pusher_channel, event, json)
    rescue Pusher::Error => ex
      #TODO: Figure out what to do with errors
    end
  end
end
