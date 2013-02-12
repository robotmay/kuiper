Kuiper.IndexRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set('title', 'Wibble')
    controller.set('sites', Kuiper.Site.find())
