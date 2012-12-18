class Kuiper.SitesController extends Kuiper.ApplicationController
  routingKey: 'sites'

  index: (params) ->
    
  show: (params) ->
    Kuiper.Site.find params.id, (err, site) =>
      throw err if err
      @set 'site', site
      @set 'visits', site.recent_visits
    
  create: (params) ->
    
  update: (params) ->
    
  destroy: (params) ->
    
