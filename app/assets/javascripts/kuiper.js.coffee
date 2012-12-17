Kuiper = $.sammy ->
  @element_selector = "#workspace"

  @get "#/", (context) ->

Kuiper.Base = Stapes.create().extend()

Kuiper.IdentityMap = Kuiper.Base.create().extend
  clear: ->
    #TODO: Clear all records

  find: (id) ->
    records = @filter (record) ->
      record.get('id') == id
    console.log records
    records[0]

  add: (record) ->
    @push record
    @find record.get('id')

  findOrAdd: (id, addCallback) ->
    mapRecord = @find(id)

    if !mapRecord
      console?.log "Record not found in identity map"
      mapRecord = addCallback (record) =>
        @add(record)
    else
      console?.log "Record found in identity map"

    mapRecord

Kuiper.Model = Kuiper.Base.create().extend
  identityMap: Kuiper.IdentityMap.create()
  path: ""

  find: (id, callback) ->
    record = @identityMap.findOrAdd id, (addCallback) =>
      $.getJSON @recordPath(id), (data) =>
        record = addCallback @create().set(data)
        callback(record)

  recordPath: (id) ->
    "#{@path}/#{id}.json"
    
Kuiper.Collection = Kuiper.Base.create().extend
  path: ""
  model: null

  all: ->
    @getAllAsArray()

  find: (id) ->
    items = @filter (item) ->
      item.get('id') == id

    items[0]

  add: (modelOrObject) ->
    if modelOrObject instanceof model
      @push model
    else
      @push new model().set(modelOrObject)

  addOrUpdate: (obj) ->
    existing = @find obj('id')
    if existing
      existing.set(obj)
    else
      @add(obj)

  fetch: ->
    $.getJSON @path, (data) ->
      for obj in data
        @addOrUpdate(obj)

Kuiper.Site = Kuiper.Model.create().extend
  path: "/sites"

Kuiper.SiteCollection = Kuiper.Collection.create().extend
  path: "/sites"
  model: Kuiper.Site

window.Kuiper = Kuiper
