Kuiper.Pusher = (opts = {}) ->
  @init(opts)
  this

$.extend Kuiper.Pusher.prototype,
  options: {}
  activeChannels: []

  init: (@options) ->
    @pusher = new Pusher(@options.key)
    @pusher.connection.bind 'connected', => @connected()
    @store = @options.store

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
    channelName = "#{@options.channelPrefix}-#{@modelName(model)}"
    channel = @pusher.subscribe(channelName)
    console.log [channelName, channel]
    channel.bind 'created', (data) ->
      console?.log ['created', data]
      @store.load(model.constructor, data)

    channel.bind 'updated', (data) =>
      console?.log ['updated', data]
      @store.load(model.constructor, data)

    channel.bind 'destroyed', (data) ->
      console?.log ['destroyed', data]
    
  modelName: (model) ->
    parts = model.toString().split('.')
    name = parts[parts.length - 1]
    name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)
