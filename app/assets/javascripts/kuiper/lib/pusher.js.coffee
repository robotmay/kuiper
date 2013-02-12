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

    channel.bind 'created', (data) =>
      @store.load(model, data)

    channel.bind 'updated', (data) =>
      modelNode = data[@modelName(model)]
      record = model.find(modelNode.id)
      record.get('store').load(model, modelNode)
    
  modelName: (model) ->
    parts = model.toString().split('.')
    name = parts[parts.length - 1]
    name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)
