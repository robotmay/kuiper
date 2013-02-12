class SiteSerializer < ActiveModel::Serializer
  attributes :id, :account_id, :name, :hits, :unique_hits, :online_visitors,
             :pusher_channel
  has_many :pages, embed: :ids, include: true
end
