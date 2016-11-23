require "calagator/decode_html_entities_hack"
require "calagator/strip_whitespace"
require "calagator/url_prefixer"
require "paper_trail"
require "loofah-activerecord"
require "loofah/activerecord/xss_foliate"
require "validate_url"

module Calagator

class User < ActiveRecord::Base
  self.table_name = "users"

  include StripWhitespace

  has_paper_trail

  xss_foliate :sanitize => [:description, :access_notes]
  include DecodeHtmlEntitiesHack

  # Associations
  has_many :events, -> { non_duplicates }, dependent: :nullify

end
end
