class Kuiper.Page extends Batman.Model
  @resourceName: 'page'
  @storageKey: 'pages'
  @persist Batman.RailsStorage

  @belongsTo 'site', { inverseOf: 'pages' }
  @hasMany 'visits', { inverseOf: 'pages' }

  @encode 'site_id', 'id', 'path'
