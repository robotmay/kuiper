class DashboardController < ApplicationController
  respond_to :html
  protect_from_forgery except: :auth

  def show

  end

  def auth
    if user_signed_in?
      if current_user.available_pusher_channels.include?(params[:channel_name])
        response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
        render json: response
      else
        render text: "Forbidden", status: 403
      end
    else
      render text: "Forbidden", status: 403
    end
  end
end
