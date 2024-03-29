class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_account
  before_filter :authenticate_user!

  def current_account
    @current_account ||= current_user.account
  end
end
