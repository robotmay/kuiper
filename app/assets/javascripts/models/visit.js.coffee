class Kuiper.Visit extends Batman.Model
  @resourceName: 'visit'
  @storageKey: 'visits'
  @persist Batman.RailsStorage

  @belongsTo 'site'
  @belongsTo 'page'

  @encode 'site_id', 'id', 'timestamp', 'site_id', 'browser',
          'platform', 'screen_size', 'browser_inner_size',
          'url', 'path'

