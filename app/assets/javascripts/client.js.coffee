#= require underscore
#= require uuid

timestamp = new Date()

class Castle
  default_options:
    api_key: null
    api_base_url: "http://api.castle.io"
    api_track_path: "/track.gif"
    current_user: null
    debug: false
    cookie_prefix: "_castle_"

  constructor: (options = {}) ->
    @options = _.extend(@default_options, options)

  run: ->
    if @options.api_key
      data = this.gather()
      this.track(data)
    else
      log("No API key specified")

  timestamp: ->
    timestamp.getTime() / 1000

  visitorID: ->
    uuid = this.getCookie("id")
    if !uuid
      uuid = this.generateID()
      this.setCookie("id", uuid)
    
    this.log(uuid)
    uuid

  previousVisit: ->
    previous_visit = this.getCookie("previous_visit")
    this_visit = this.timestamp()
    this.setCookie("previous_visit", this_visit, 1800)

    this.log(previous_visit)
    previous_visit

  previousPage: ->
    previous_page = this.getCookie("previous_page")
    this.setCookie("previous_page", location.href, this.days_in_seconds(1))

    this.log(previous_page)
    previous_page

  gather: ->
    visitor_id = this.visitorID()
    previous_visit = this.previousVisit()
    previous_page = this.previousPage()

    data =
      api_key: @options.api_key
      timestamp: this.timestamp()
      visitor_id: visitor_id
      previous_visit: previous_visit
      previous_page: previous_page
      browser:
        user_agent: navigator.userAgent
        cookies_enabled: navigator.cookieEnabled
        java_enabled: navigator.javaEnabled()
        plugins: _.map(navigator.plugins, (plugin) ->
          name: plugin.name
          version: plugin.version
          filename: plugin.filename
        )
      system:
        screen:
          height: screen.height
          width: screen.width
          colour_depth: screen.pixelDepth
          available_height: screen.availHeight
          available_width: screen.availWidth
      page:
        url: location.href
        referrer: document.referrer
        title: document.title
        last_modified: document.lastModified

    # system fonts
    # geolocation info
    # HTTP accept header
    
    this.log(data)
    return data

  track: (payload) ->
    data = encodeURIComponent(JSON.stringify(payload))
    url = [@options.api_base_url, @options.api_track_path, "?payload=#{data}"].join("")
    image = new Image()
    image.src = url

  generateID: ->
    generateUUID()

  getCookie: (key) ->
    name = "#{@options.cookie_prefix}#{key}="
    components = document.cookie.split(";")
    for element, i in components
      while element.charAt(0) is " "
        element = element.substring(1, element.length)

      if element.indexOf(name) is 0
        return element.substring(name.length, element.length)

    return null

  setCookie: (key, value, expires_in = null) ->
    unless expires_in
      expires_in = this.days_in_seconds(512)
    expires_at = new Date()
    expires_at.setTime(expires_at.getTime + (expires_in * 1000))

    document.cookie = "#{@options.cookie_prefix}#{key}=#{value}; expires=#{expires_at.toGMTString()}; path=/"

  days_in_seconds: (days) ->
    days * 24 * 60 * 60

  log: (message, force = false) ->
    if @options.debug || force
      console.log message

window.Castle = Castle
