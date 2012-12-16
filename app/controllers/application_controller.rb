class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_account

  def current_account
    current_user.account if user_signed_in?
  end
end
