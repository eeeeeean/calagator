require "calagator/duplicate_checking/controller_actions"

module Calagator

class BranchesController < VenuesController

  def index
    @search = Venue::Search.new(params.merge(branch: '1'))
    @venues = @search.venues #make it node scope!

    flash[:failure] = @search.failure_message
    return redirect_to venues_path if @search.hard_failure?
    render_venues @venues
  end

  def map
    @branches = Venue.all.branch
  end
end
end
