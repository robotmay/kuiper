Kuiper.Page = DS.Model.extend()
  site: DS.belongsTo('Kuiper.Site')
  visits: DS.hasMany('Kuiper.Visit')
