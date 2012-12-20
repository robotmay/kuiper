class VisitsController < ApplicationController
  respond_to :json

  before_filter do
    @site = current_user.sites.find(params[:site_id])
  end

  def index
    @visits = @site.visits.expanded.includes(:browser, :platform).order("timestamp DESC").limit(10)
    @visits = @visits.map { |v| VisitDecorator.new(v) }
    respond_with @visits
  end

  def show
  end
end
