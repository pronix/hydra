class AddMediavaliselinksToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :mediavalise_links, :text
  end

  def self.down
    remove_column :tasks, :mediavalise_links
  end
end
