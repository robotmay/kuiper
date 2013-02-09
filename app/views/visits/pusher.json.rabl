object @data
attributes :model_name
child :model_data => :model_data do
  attributes :id, :timestamp, :site_id, :url, :screen_size, :browser_inner_size
  child(:page) { attributes :path, :name }
  child(:browser) { attributes :name, :short_name }
  child(:platform) { attributes :name, :short_name }
end
