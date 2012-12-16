class BatmanPusher
  constructor: (channel) ->
    @channel = channel
    @channel.bind "updated",   (pushed_data) => @delayIfXhrRequests('updated', pushed_data)
    @channel.bind "created",   (pushed_data) => @delayIfXhrRequests('created', pushed_data)
    @channel.bind "destroyed", (pushed_data) => @delayIfXhrRequests('destroyed', pushed_data)

  getModelAndObject: (pushed_data) ->
    model = Batman.currentApp[pushed_data.model_name]
    data = pushed_data.model_data
    obj = new model()
    obj._withoutDirtyTracking -> obj.fromJSON(data)
    return [model, obj]

  delayIfXhrRequests: (method, pushed_data) ->
    if BatmanPusher.activeXhrCount == 0
      @[method](pushed_data)
    else
      console?.log("DELAYING #{method}: #{JSON.stringify(pushed_data)}")
      setTimeout =>
        @delayIfXhrRequests(method, pushed_data)
      , 500

  created: (pushed_data) ->
    [model, obj] = @getModelAndObject(pushed_data)
    console?.log("created: #{JSON.stringify(pushed_data)}")
    model._mapIdentity(obj)

  updated: (pushed_data) ->
    [model, obj] = @getModelAndObject(pushed_data)
    console?.log("updated #{JSON.stringify(pushed_data)}")
    existing = model.get('loaded.indexedBy.id').get(obj.get('id'))
    if existing && existing._storage[0]
      model._mapIdentity(obj).fire("change")

  destroyed: (pushed_data) ->
    console?.log("destroyed #{JSON.stringify(pushed_data)}")
    [model, obj] = @getModelAndObject(pushed_data)
    existing = model.get('loaded.indexedBy.id').get(obj.get('id'))
    if existing && existing._storage[0]
      model.get('loaded').remove(existing._storage[0])

@BatmanPusher = BatmanPusher
@BatmanPusher.activeXhrCount = 0
$(document).ajaxSend(=> @BatmanPusher.activeXhrCount++ ).ajaxComplete(=> @BatmanPusher.activeXhrCount--)

