module Calagator

class SiteController < Calagator::ApplicationController

  before_action :set_current_location, only: [:index]

  # Raise exception, mostly for confirming that exception_notification works
  def omfg
    raise ArgumentError, "OMFG"
  end

  # Render something to help benchmark stack without the views
  def hello
    render :text => "hello"
  end

  def index
    @overview = Event::Overview.new current_location
    respond_to do |format|
      format.html { }
      format.any  { redirect_to events_path(format: params[:format]) }
    end
  end

  # Displays the about page.
  def about; end

  def opensearch
    respond_to do |format|
      format.xml { render :content_type => 'application/opensearchdescription+xml' }
    end
  end

  def defunct
    @url = params[:url]
    raise ArgumentError if /^javascript:/.match(@url)
  end

  def set_current_location
    @current_location = current_location
  end
end

end
