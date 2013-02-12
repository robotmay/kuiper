DS.Model.reopenClass
  getChannelPrefix: (callback) ->
    @channelPrefix || $.get "/accounts/current.json", (data) ->
      @channelPrefix = data['account']['pusher_channel']
      callback(@channelPrefix)

  getChannelName: (callback) ->
    model = this
    parts = model.toString().split('.')
    name = parts[parts.length - 1]
    name = name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)

    @getChannelPrefix (channel) ->
      callback("#{channel}-#{name}")

  subscribe: ->
    model = this
    pusher = EmberPusherInstance.get('pusher')
    @getChannelName (channel) ->
      channel = pusher.subscribe(channel)

      channel.bind 'created', (data) ->
        console?.log(data)
        DS.defaultStore.load(model, data.hash)

      channel.bind 'updated', (data) ->
        console?.log(data)

