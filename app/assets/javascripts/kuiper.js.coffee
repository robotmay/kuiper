Kuiper = $.sammy ->
  @element_selector = "#workspace"

  @get "#/", (context) ->

Kuiper.Base = Stapes.create().extend
  ajax: jQuery.ajax

Kuiper.IdentityMap = Kuiper.Base.create().extend
  delete: (id) ->
    #TODO: Delete a single record
  clear: ->
    #TODO: Clear all records

  find: (id) ->
    records = @filter (record) ->
      record.get('id') == id
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
  format: "json"

  recordPath: (id) ->
    "#{@path}/#{id}.#{@format}"

  find: (id, successCallback) ->
    record = @identityMap.findOrAdd id, (addCallback) =>
      @fetch id, (record) =>
        mappedRecord = addCallback(record)
        @emit "loaded"
        successCallback(mappedRecord)

  fetch: (id, successCallback) ->
    $.getJSON @recordPath(id), (data) =>
      record = @create().set(data)
      successCallback(record)

  updateAttributes: (obj, createNew = false) ->
    for key, value in obj
      if @has(key) or createNew
        @set key, value
          
Kuiper.Collection = Kuiper.Base.create().extend
  model: null
  path: model.create().path

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
