class CreateMarkerColumns < ActiveRecord::Migration
  def self.up
    add_column :events, :informational, :boolean, default: false
    add_column :events, :emergency,     :boolean, default: false
    add_column :venues, :ally,     :boolean, default: false
    add_column :venues, :branch,          :boolean, default: false
  end

  def self.down
    remove_column :events, :informational
    remove_column :events, :emergency
    remove_column :venues, :ally
    remove_column :venues, :branch
  end
end
