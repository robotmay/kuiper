window.Kuiper = Ember.Namespace.create Ember.Evented,
  config:
    pusher_key: $('meta[name="kuiper.pusher_key"]').attr('value')

  run: (attrs) ->
    Ember.run.next this, ->
      app = Kuiper.App.create(attrs || {})
      @app = app
      @store = app.store
      $ => app.initialize()

