class AccountsController < ApplicationController
  respond_to :html, :json

  def show
    @account = Account.find(params[:id])
    authorize! :read, @account
    respond_with @account
  end

  def current
    @current_account = current_user.account.decorate
    respond_with @current_account
  end
end
