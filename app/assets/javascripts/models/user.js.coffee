class Kuiper.User extends Batman.Model
  @resourceName: 'user'
  @storageKey: 'users'
  @persist Batman.RailsStorage

  @encode "id", "email", "account_id"

