class Kuiper.Site extends Batman.Model
  @resourceName: 'site'
  @storageKey: 'sites'
  @persist Batman.RailsStorage

  @hasMany 'pages'
  @hasMany 'visits'

  @encode "name", "api_key", "allowed_hosts", "hits", "unique_hits", "online_visitors", "recent_visits"
