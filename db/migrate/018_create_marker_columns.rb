class CreateMarkerColumns < ActiveRecord::Migration
  def self.up
    add_column :events, :informational, :boolean, default: false
    add_column :events, :emergency,     :boolean, default: false
    add_column :venues, :openhouse,     :boolean, default: false
    add_column :venues, :node,          :boolean, default: false
  end

  def self.down
    remove_column :events, :informational
    remove_column :events, :emergency
    remove_column :venues, :openhouse
    remove_column :venues, :node
  end
end
