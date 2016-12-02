module Calagator

class SiteController < Calagator::ApplicationController

  # Raise exception, mostly for confirming that exception_notification works
  def omfg
    raise ArgumentError, "OMFG"
  end

  def code_error
  end

  def today
    @events = Event.joins(:venue).within_dates(Time.now, Time.now)
  end

  # Render something to help benchmark stack without the views
  def hello
    render :text => "hello"
  end

  def index
    @overview = Event::Overview.new current_region_hash
    respond_to do |format|
      format.html { }
      format.any  { redirect_to events_path(format: params[:format]) }
    end
  end

  # Displays the about page.
  def about; end

  # Displays the contact page
  def faq; end

  def opensearch
    respond_to do |format|
      format.xml { render :content_type => 'application/opensearchdescription+xml' }
    end
  end

  def defunct
    @url = params[:url]
    raise ArgumentError if /^javascript:/.match(@url)
  end

end

end
