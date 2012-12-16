class Account < ActiveRecord::Base
  has_many :users
  has_many :sites
  
  def pusher_channel
    "private-account-#{id}"
  end
end
