class PageSerializer < ActiveModel::Serializer
  attributes :id, :name, :path, :hits, :unique_hits
end
