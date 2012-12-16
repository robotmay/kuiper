class UsersController < ApplicationController
  respond_to :json

  def current
    @user = current_user
    respond_with @user
  end
end
