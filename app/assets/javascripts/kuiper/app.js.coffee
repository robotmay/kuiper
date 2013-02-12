Kuiper.reopen
  App: Ember.Application.extend
    autoinit: false
    rootElement: '#main'

    init: ->
      @_super.apply this, arguments

      @store = Kuiper.Store.create()
      @pusher = EmberPusher.create(Kuiper.config.pusher_key)

      @set "currentUser", Kuiper.User.find("current")
      @set "currentAccount", Kuiper.Account.find("current")

      Kuiper.Site.subscribe()
      Kuiper.Page.subscribe()

