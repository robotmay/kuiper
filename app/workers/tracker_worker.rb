class TrackerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :incoming

  def perform(client_data, server_data)
    client_data = JSON.parse(client_data, symbolize_names: true)
    server_data = JSON.parse(server_data, symbolize_names: true)
    
    payload = client_data.merge(server_data)
    Visit.create_from_client_data(payload)
  end
end
