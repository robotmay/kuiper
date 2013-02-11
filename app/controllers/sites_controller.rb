class SitesController < ApplicationController
  respond_to :json

  def index
    @sites = current_account.sites.order("name ASC")
    @sites = @sites.map { |site| SiteDecorator.new(site) }
    respond_with @sites
  end

  def show
    @site = current_account.sites.find(params[:id]).decorate
    respond_with @site
  end

  def create
    @site = current_account.sites.new(params[:site]).decorate
    if @site.save
      respond_with @site
    else
      respond_with @site, status: :unprocessable_entity
    end
  end

  def update
    @site = current_account.sites.find(params[:id]).decorate
    if @site.update_attributes(params[:site])
      respond_with @site
    else
      respond_with @site, status: :unprocessable_entity
    end
  end
end
