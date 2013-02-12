class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :account_id
end
