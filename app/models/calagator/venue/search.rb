module Calagator

class Venue < ActiveRecord::Base
  class Search < Struct.new(:tag, :query, :wifi, :branch, :all, :closed, :include_closed)
    def initialize attributes = {}
      puts "attributes are: #{attributes.inspect}"
      members.each do |key|
        send "#{key}=", attributes[key]
      end
    end

    def venues
      @venues ||= perform_search
    end

    def most_active_venues
      base.business.wifi_status.scope.order('events_count DESC').limit(10)
    end

    def newest_venues
      base.business.wifi_status.scope.order('created_at DESC').limit(10)
    end

    def results?
      query || tag || all
    end

    def failure_message
      @failure_message
    end

    def hard_failure?
      @hard_failure
    end

    protected

    def perform_search
      if query
        puts "There is a query"
        Venue.search(query, include_closed: include_closed, wifi: wifi, branch: branch)
      else
        base.business.wifi_status.branch_status.search.scope
      end
    rescue ActiveRecord::StatementInvalid => e
      @failure_message = "There was an error completing your search."
      @hard_failure = true
      []
    end

    def base
      @scope = Venue.non_duplicates
      self
    end

    def business
      if closed
        @scope = @scope.out_of_business
      elsif !include_closed
        @scope = @scope.in_business
      end
      self
    end

    def wifi_status
      @scope = @scope.with_public_wifi if wifi
      self
    end

    def branch_status
      @scope = @scope.branch if branch
      self
    end

    def search
      @scope = @scope.tagged_with(tag) if tag.present? # searching by tag
      self
    end

    def scope
      @scope
    end
  end
end

end
