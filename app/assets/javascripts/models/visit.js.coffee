class Kuiper.Visit extends Batman.Model
  @storageKey: 'visits'
  @persist Batman.RailsStorage

  @belongsTo 'site'

  @encode 'site_id', 'id', 'timestamp', 'site_id', 'browser', 
          'platform', 'screen_size', 'browser_inner_size',
          'url', 'path'

