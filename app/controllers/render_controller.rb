class RenderController < ApplicationController
  include Subdomain
  require 'html_press'

  layout 'page'
  skip_before_filter :require_login
  before_filter :find_user_site

  def show
    @page = @site.pages.find_by_name!(params[:page])
    @content = @page.content
    @content = parser([], nil, @content)
  end

  def index
    @index = @site.pages.where(:system => true).first!
    @content = @index.content
    @content = parser([], nil, @content)
  end

  def stylesheet
    @stylesheet = @site.stylesheets.find_by_name!(params[:stylesheet])
    respond_to do |format|
      format.css
    end
  end

  def javascript
    @javascript = @site.javascripts.find_by_name!(params[:javascript])
    respond_to do |format|
      format.js
    end
  end

  private

  def parser stack, segment, content
    return "" unless content
    return "[::deep includes::]" if stack.length > 10
    return "[::includes error::]" if stack.include?(segment)
    content.gsub!(/\s*\[% +include +'?(.+?)'? +%\]\s*/) do |template|
      parser(stack.push(segment), $1, @t.content) if @t = @site.templates.find_by_name($1)
    end
    if content =~ /\s*\[% +layout +'?(.+?)'? +%\]\s*/
      if @l = @site.layouts.find_by_name($1)
        layout = parser(stack.push(segment), "%#{$1}", @l.content)
        
        layout.gsub!(/\s*\[% +yield +%\]\s*/, content)
        content = layout
      end
      content.gsub!(/\s*\[% +layout +'?(.+?)'? +%\]\s*/, '')
    end
    HtmlPress.press(content)
  end
  
  def find_user_site
    if @domain = Domain.find_by_name(request.domain)
      @site = @domain.sites.find_by_name!(request.subdomain(Subdomain.position))
      unless @site.own_domain.blank?
        return redirect_to "http://#{@site.own_domain}#{request.path}"
      end
    else
      @site = Site.find_by_own_domain!(request.domain)
    end
  end
end
