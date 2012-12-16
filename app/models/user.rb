class User < ActiveRecord::Base
  belongs_to :account
  has_many :sites, through: :account
  has_many :pages, through: :sites

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def available_pusher_channels
    channels = []
    channels << account.pusher_channel
    channels
  end
end
