object @data
attributes :model_name
child :model_data => :model_data do
  attributes :id, :timestamp, :site_id, :url, :screen_size, :browser_inner_size
  child(:page) { attributes :id, :site_id, :name, :path, :hits, :unique_hits }
  child(:browser) { attributes :id, :name, :short_name }
  child(:platform) { attributes :id, :name, :short_name }
end
