class SitesController < ApplicationController
  respond_to :json

  def index
    @sites = current_user.sites.order("name ASC")
    @sites = SiteDecorator.decorate_collection(@sites)
    respond_with @sites
  end

  def show
    @site = current_user.sites.find(params[:id])
    @site = SiteDecorator.new(@site)
    respond_with @site
  end

  def create
    @site = current_user.sites.new(params[:site])
    @site = SiteDecorator.new(@site)
    if @site.save
      respond_with @site
    else
      respond_with @site, status: :unprocessable_entity
    end
  end

  def update
    @site = current_user.sites.find(params[:id])
    @site = SiteDecorator.new(@site)
    if @site.update_attributes(params[:site])
      respond_with @site
    else
      respond_with @site, status: :unprocessable_entity
    end
  end
end
