DS.Model.reopenClass
  modelName: ->
    model = this
    parts = model.toString().split('.')
    name = parts[parts.length - 1]
    name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)

  getChannelPrefix: (callback) ->
    @channelPrefix || $.get "/accounts/current.json", (data) ->
      @channelPrefix = data['account']['pusher_channel']
      callback(@channelPrefix)

  getChannelName: (callback) ->
    name = @modelName()
    @getChannelPrefix (channel) ->
      callback("#{channel}-#{name}")

  subscribe: ->
    model = this
    pusher = EmberPusherInstance.get('pusher')
    @getChannelName (channel) ->
      channel = pusher.subscribe(channel)

      channel.bind 'created', (data) ->
        console?.log ['created', data]
        DS.defaultStore.load(model.constructor, data)

      channel.bind 'updated', (data) ->
        console?.log ['updated', data]
        DS.defaultStore.load(model.constructor, data)

      channel.bind 'destroyed', (data) ->
        console?.log ['destroyed', data]
        record = model.find(data.id)
        unless record.get('isDeleted')
          record.unloadRecord()
