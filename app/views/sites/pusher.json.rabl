object @data
attributes :model_name
child :model_data => :model_data do
  attributes :id, :name, :api_key, :allowed_hosts, :hits, :unique_hits, :online_visitors, :online_visitor_counts
end
