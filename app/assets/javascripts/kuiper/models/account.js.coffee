Kuiper.Account = DS.Model.extend
  pusherChannel: DS.attr('string')

  sites: DS.hasMany('sites')
   
  channelName: (model = nil) ->
    if model
      "#{@pusherChannel}-#{model}"
    else
      @pusherChannel
