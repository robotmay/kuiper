Kuiper.Pusher = (key) ->
  @init(key) if key
  this

$.extend Kuiper.Pusher.prototype,
  activeChannels: []

  init: (@key, @prefix, @store) ->
    @pusher = new Pusher(@key)
    @pusher.connection.bind 'connected', => @connected()

  connected: ->
    @socketID = @pusher.connection.socket_id
    @addSocketIDToXHR()

  addSocketIDToXHR: ->
    Ember.$.ajaxPrefilter (options, originalOptions, xhr) =>
      xhr.setRequestHeader 'X-Pusher-Socket', @socketID

  subscribeModels: (models = []) ->
    for model in models
      @subscribeModel(model)

  subscribeModel: (model) ->
    channelName = "#{@prefix}-#{@modelName(model)}"
    channel = @pusher.subscribe(channelName)

    channel.bind 'created', (data) ->
      console?.log ['created', data]
      @store.load(model.constructor, data)

    channel.bind 'updated', (data) ->
      console?.log ['updated', data]
      @store.load(model.constructor, data)

    channel.bind 'destroyed', (data) ->
      console?.log ['destroyed', data]
    
  modelName: (model) ->
    parts = model.toString().split('.')
    name = parts[parts.length - 1]
    name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)
