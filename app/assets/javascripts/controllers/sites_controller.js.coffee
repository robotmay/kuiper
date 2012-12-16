class Kuiper.SitesController extends Kuiper.ApplicationController
  routingKey: 'sites'

  index: (params) ->
    
  show: (params) ->
    site = Kuiper.Site.find params.id, (err) ->
      throw err if err

    site.observe "hits", (newVal, oldVal) -> console.log [newVal, oldVal]

    @set 'site', site
    
  create: (params) ->
    
  update: (params) ->
    
  destroy: (params) ->
    
