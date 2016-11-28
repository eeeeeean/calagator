require 'geokit-rails'
module Calagator

class Event < ActiveRecord::Base
  class Overview

    def initialize location
      @venues = Venue.within(REGION_RADIUS, origin: location )
      @events = Event.where(venue_id: @venues.map(&:id))
    end

    def today
      @events.non_duplicates.within_dates(today_date, tomorrow_date)
    end

    def tomorrow
      @events.non_duplicates.within_dates(tomorrow_date, after_tomorrow_date)
    end

    def later
      @events.non_duplicates.within_dates(after_tomorrow_date, future_cutoff_date)
    end

    def more
      @events.after_date(future_cutoff_date).first
    end

    def tags
      @tags ||= @events.tag_counts_on(:tags, limit: 100, conditions: "tags_count >= 10").sort_by(&:name)
    end

    private

    def today_date
      @today_date ||= Time.zone.now.beginning_of_day
    end

    def tomorrow_date
      today_date + 1.day
    end

    def after_tomorrow_date
      tomorrow_date + 1.day
    end

    def future_cutoff_date
      today_date + 2.weeks
    end
  end
end

end
