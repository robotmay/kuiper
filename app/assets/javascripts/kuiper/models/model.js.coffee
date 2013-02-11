DS.Model.reopenClass
  channelName: ->
    model = this
    parts = model.toString().split('.')
    name = parts[parts.length - 1]
    name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)

  subscribe: ->
    @model = this
    @pusher = EmberPusher.create()
    @channel = @pusher.subscribe(@channelName())

    @channel.bind 'create', (data) ->
      console?.log(data)
      DS.defaultStore.load(@model, data.hash)
