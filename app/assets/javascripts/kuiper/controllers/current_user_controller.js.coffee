Kuiper.CurrentUserController = Ember.ObjectController.extend
  content: null

  init: ->
    @getCurrentUser()

  getCurrentUser: ->
    @set "content", Kuiper.User.find("current")
  
