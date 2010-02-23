class RenameFieldInTasks < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :create_arhive, :create_archive
  end

  def self.down
    rename_column :tasks, :create_archive, :create_arhive
  end
end
