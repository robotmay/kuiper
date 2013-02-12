class Account < ActiveRecord::Base
  has_many :users
  has_many :sites
  
  def pusher_channel(model = nil)
    "private-account-#{id}#{['-', model].join if model.present?}"
  end
end
