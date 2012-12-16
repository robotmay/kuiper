class PagesController < ApplicationController
  respond_to :json

  before_filter do
    @site = current_account.sites.find(params[:site_id])
  end

  def index
    @pages = @site.pages.order("path ASC")
    @pages = PageDecorator.decorate_collection(@pages)
    respond_with @pages
  end

  def show
    @page = @site.pages.find(params[:id])
    @page = PageDecorator.new(@page)
    respond_with @page
  end
end
