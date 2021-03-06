# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

module Calagator

class ApplicationController < ActionController::Base
  helper Calagator::EventsHelper
  helper Calagator::ApplicationHelper
  helper Calagator::EventsHelper
  helper Calagator::GoogleEventExportHelper
  helper Calagator::MappingHelper
  helper Calagator::SourcesHelper
  helper Calagator::TagsHelper
  helper Calagator::TimeRangeHelper

  require 'figaro'

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8813a7fec0bb4fbffd283a3868998eed'
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_action :set_current_region

  def set_current_region
    session[:region] = params[:region] if params[:region]
    Time.zone = current_region_hash[:zone]
    @current_region_hash = current_region_hash
  end

  def current_region_hash
    index = LOCATIONS.index { |e| e[:name] == current_region }
    LOCATIONS[index]
  end

  def current_region
    session[:region] ||= 'Portland, OR, USA'
  end

  def log_action
    logger
  end

protected

  def check_code
    return if session[:authenticated]
    if params[:code] && code_key.present?
      session[:authenticated] = code_key
    else
      redirect_to code_error_path unless params[:code] && code_passes?
    end
  end

  def code_key
    result = Rails.application.secrets.find { |e| e[1] == params[:code] }
    result ? [0].to_s : nil
  end

  def json_request?
    request.format.json?
  end

  def self.require_admin(options = {})
    http_basic_authenticate_with(
      options.reverse_merge(
        :name => Calagator.admin_username,
        :password => Calagator.admin_password,
        :if => Proc.new { Calagator.admin_username && Calagator.admin_password }
      )
    )
  end

  #---[ Helpers ]---------------------------------------------------------

  # Returns a data structure used for telling the CSS menu which part of the
  # site the user is on. The structure's keys are the symbol names of resources
  # and their values are either "active" or nil.
  def link_class
    return @_link_class_cache ||= {
      :events => (( controller_name == 'events' ||
                    controller_name == 'sources' ||
                    controller_name == 'site' && action_name == 'index')  && 'active'),
      :venues => (controller_name == 'venues'  && 'active'),
      :branches => (controller_name == 'branches' && 'active'),
      :faq => (controller_name == 'site' && action_name == 'faq' && 'active')
    }
  end
  helper_method :link_class

  #---[ Misc ]------------------------------------------------------------

  # Set or append flash +message+ (e.g. "OMG!") to flash key with the name
  # +kind+ (e.g. :failure).
  def append_flash(kind, message)
    kind = kind.to_sym
    if leaf = flash[kind]
      flash[kind] = "#{leaf} #{message}"
    else
      flash[kind] = "#{message}"
    end
  end

  # Make it possible to use helpers in controllers
  # http://www.johnyerhot.com/2008/01/10/rails-using-helpers-in-you-controller/
  class Helper
    include Singleton
    include ActionView::Helpers::UrlHelper # Provide: #link_to
    include ActionView::Helpers::TagHelper # Provide: #escape_once (which #link_to needs)
  end

  def help
    Helper.instance
  end

  # Return string with contents HTML escaped once.
  def escape_once(*args)
    help.escape_once(*args)
  end
end

end
