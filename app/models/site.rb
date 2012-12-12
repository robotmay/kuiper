class Site < ActiveRecord::Base
  has_many :visits
  attr_accessible :api_key, :name, :user_id, :allowed_hosts
end
