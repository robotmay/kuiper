Kuiper = $.sammy ->
  @element_selector = "#workspace"

  @get "#/", (context) ->

Kuiper.Base = Stapes.create().extend()
  # Useful for base extensions

Kuiper.Model = Kuiper.Base.create().extend
  path: ""

  find: (id, callback) ->
    $.getJSON @recordPath(id), (data) =>
      model = @create().set(data)
      callback(model)

  recordPath: (id) ->
    "#{@path}/#{id}.json"
    
Kuiper.Collection = Kuiper.Base.create().extend
  path: ""
  model: null

  all: ->
    @getAllAsArray()

  find: (id) ->
    @filter (item) ->
      item.id is id

  fetch: ->
    $.getJSON @path, (data) ->
      for obj in data
        existing = @find(obj.id)
        if existing
          existing.set(obj)
        else
          new_record = new model()
          @push new_record.set(obj)

Kuiper.Site = Kuiper.Model.create().extend
  path: "/sites"

Kuiper.SiteCollection = Kuiper.Collection.create().extend
  path: "/sites"
  model: Kuiper.Site

window.Kuiper = Kuiper
