#= require underscore

class Castle
  default_options:
    api_key: null
    api_base_url: "http://api.castle.io"
    api_track_path: "/track.gif"
    always_set_cookies: false
    current_user: null
    debug: false

  constructor: (options = {}) ->
    @options = _.extend(@default_options, options)

  run: ->
    if @options.api_key
      data = this.gather()
      this.track(data)
    else
      log("No API key specified")
    
  gather: ->
    data =
      browser:
        user_agent: navigator.userAgent
        platform: navigator.platform
        app_name: navigator.appName
        app_code_name: navigator.appCodeName
        app_version: navigator.appVersion
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
          color_depth: screen.pixelDepth
          available_height: screen.availHeight
          available_width: screen.availWidth
      page:
        url: location.href
        host: location.host
        hostname: location.hostname
        path: location.pathname
        port: location.port
        protocol: location.protocol
        query: location.search
        hash: location.hash
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

  getCookie: (key) ->
    name = "#{key}="
    components = document.cookie.split(";")
    for element, i in components
      while element.charAt(0) is " "
        element = element.substring(1, element.length)

      if element.indexOf(name) is 0
        return element.substring(name.length, element.length)

    return null

  setCookie: (key, value, expires_at = null) ->
    unless expires_at
      number_of_days = 30
      expires_at = new Date()
      expires_at.setTime(expires_at.getTime + (number_of_days * 24 * 60 * 60 * 1000))

    document.cookie = "#{key}=#{value}; expires=#{expires_at.toGMTString()}; path=/"

  log: (message, force = false) ->
    if @options.debug || force
      console.log message

window.Castle = Castle
