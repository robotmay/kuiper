class Kuiper.Page extends Batman.Model
  @resourceName: 'site'
  @storageKey: 'pages'
  @persist Batman.RailsStorage

  @belongsTo 'site', { inverseOf: 'pages' }
