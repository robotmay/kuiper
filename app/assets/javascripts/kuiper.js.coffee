window.Kuiper = Ember.Application.create
  rootElement: '#main'

  config:
    pusherKey: $('meta[name="kuiper.pusher_key"]').attr('value')

  ready: ->
    @store = Kuiper.Store.create()

    @set 'currentUser', Kuiper.User.find('current')
    @set 'currentAccount', Kuiper.Account.find('current')

    @get('currentAccount').on 'didLoad', =>
      channelPrefix = @get('currentAccount').get('pusherChannel')
      @pusher = new Kuiper.Pusher
        key: Kuiper.config.pusherKey
        channelPrefix: channelPrefix,
        store: @store
      @pusher.subscribeModels [Kuiper.Site, Kuiper.Page]
