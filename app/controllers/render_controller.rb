class RenderController < ApplicationController
  include Subdomain
  require 'html_press'

  layout 'page'
  before_filter :find_user_site

  def show
    respond_to do |format|
      format.html {
        searcher(params[:page], 'html')
      }
      format.text {
        searcher(params[:page], 'txt')
      }
      format.any  { render :text => '', :status => 404 }
    end
  end

  def index
    respond_to do |format|
      format.html {
        searcher('/', 'html')
      }
      format.any  { render :text => 'not found', :status => 404 }
    end
  end

  def stylesheet
    @stylesheet = @site.stylesheets.find_by_name!(params[:stylesheet])
    @content = @stylesheet.code

    respond_to do |format|
      format.css
    end
  end

  def javascript
    @javascript = @site.javascripts.find_by_name!(params[:javascript])
    @content = @javascript.content

    respond_to do |format|
      format.js
    end
  end

  def favicon
    send_file Rails.root.join('public', 'favicon', 'favicon.ico'), type: 'image/vnd.microsoft.icon', disposition: 'inline'
  end

  private

  def searcher name, kind
    @page = @site.pages.find_by_name_and_kind!(name, kind)
    @content = @page.code
  end

  def find_user_site
    if @domain = Domain.find_by_name(request.domain)
      @site = @domain.sites.find_by_name!(request.subdomain(Subdomain.position))
      unless @site.own_domain.blank?
        return redirect_to "http://#{@site.own_domain}#{request.path}"
      end
    else
      @site = Site.find_by_own_domain!(request.subdomain.to_s.blank? ? request.domain : "#{request.subdomain}.#{request.domain}")
    end
  end
end
