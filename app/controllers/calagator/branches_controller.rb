require "calagator/duplicate_checking/controller_actions"

module Calagator

class BranchesController < VenuesController

  def index
    @search = Venue::Search.new(params.permit!)
    @venues = @search.venues #make it node scope!

    flash[:failure] = @search.failure_message
    return redirect_to venues_path if @search.hard_failure?
    render_venues @venues
  end
end
end
