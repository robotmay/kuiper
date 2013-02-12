Kuiper.User = DS.Model.extend
  accountId: DS.attr("number")
  email: DS.attr("string")

  account: DS.belongsTo('Kuiper.Account')
