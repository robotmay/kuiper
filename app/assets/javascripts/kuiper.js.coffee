window.Kuiper = class Kuiper extends Batman.App
  @root 'sites#index'
  @resources 'sites', ->
    @resources 'pages'

  Batman.ViewStore.prefix = "assets/views"

  @on 'run', ->
    Kuiper.pusher = new Pusher("3379d6e6ccdeed1c69d1")

    # Load the current user
    Kuiper.current_user = new Kuiper.User()
    Kuiper.current_user.url = "/users/current"
    Kuiper.current_user.load (err, result) -> 
      throw err if err
    Kuiper.current_user.on "loaded", ->
      channel = Kuiper.pusher.subscribe("private-account-#{@get('account_id')}")
      new BatmanPusher(channel)

    console?.log "Running ...."

  @on 'ready', ->

  @flash: Batman()
  @flash.accessor
    get: (key) -> @[key]
    set: (key, value) ->
      @[key] = value
      if value isnt ''
        setTimeout =>
          @set(key, '')
        , 2000
      value

  @flashSuccess: (message) -> @set 'flash.success', message
  @flashError: (message) ->  @set 'flash.error', message
