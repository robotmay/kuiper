class Kuiper.SitesController extends Kuiper.ApplicationController
  routingKey: 'sites'

  index: (params) ->
    
  show: (params) ->
    Kuiper.Site.find params.id, (err, site) =>
      throw err if err
      @set 'site', site
      @set 'visits', site.get('visits')
      @set 'siteView', new Kuiper.SiteView
        site: @get('site')
    
  create: (params) ->
    
  update: (params) ->
    
  destroy: (params) ->
    
