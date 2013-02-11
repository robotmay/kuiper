window.EmberPusher = Ember.Object.extend
  key: null

  init: ->
    @pusher = new Pusher(@get('key'))
    @pusher.connection.bind 'connected', => @connected()

  connected: ->
    @socketID = @pusher.connection.socket_id
    @addSocketIDToXHR()

  addSocketIDToXHR: ->
    Ember.$.ajaxPrefilter (options, originalOptions, xhr) =>
      xhr.setRequestHeader 'X-Pusher-Socket', @socketID
