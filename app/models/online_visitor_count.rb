class OnlineVisitorCount < ActiveRecord::Base
  belongs_to :site
  attr_accessible :count, :site_id
end
