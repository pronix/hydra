class AddStrogeLinkImageHostingToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :links_image_hosting, :text
  end

  def self.down
    remove_column :tasks, :links_image_hosting
  end
end
