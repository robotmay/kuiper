Kuiper.Site = DS.Model.extend
  accountId: DS.attr('number')
  apiKey: DS.attr('string')
  name: DS.attr('string')
  hits: DS.attr('number')
  uniqueHits: DS.attr('number')
  onlineVisitors: DS.attr('number')

  account: DS.belongsTo('Kuiper.Account')
  visits: DS.hasMany('Kuiper.Visit')
  pages: DS.hasMany('Kuiper.Page')

  channelName: ->
    Kuiper.currentAccount.get("pusherChannel")
