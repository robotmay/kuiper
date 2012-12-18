class Kuiper.Visit extends Batman.Model
  @storageKey: 'visits'
  @persist Batman.RailsStorage

  @belongsTo 'site'

  @encode 'site_id'
