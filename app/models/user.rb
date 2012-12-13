class User < ActiveRecord::Base
  has_many :sites
  has_many :pages, through: :sites

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def available_pusher_channels
    channels = []
    channels.concat sites.map(&:pusher_channel)
    channels.concat pages.map(&:pusher_channel)
    channels
  end
end
