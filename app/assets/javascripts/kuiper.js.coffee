window.Kuiper = Ember.Application.createWithMixins
  rootElement: '#main'

  currentUser: (->
    Kuiper.User.find("current")
  ).property()

  currentAccount: (->
    Kuiper.Account.find("current")
  ).property()

  initializePusher: ->
    EmberPusher.reopen
      key: "3379d6e6ccdeed1c69d1" #TODO: Move into settings store

    window.EmberPusherInstance = EmberPusher.create()

  subscribeToChannels: ->
    @initializePusher()
    Kuiper.Site.subscribe()
    Kuiper.Page.subscribe()

  start: ->
    @subscribeToChannels()
