class AddGidToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :gid, :string
  end

  def self.down
    remove_column :tasks, :gid
  end
end
