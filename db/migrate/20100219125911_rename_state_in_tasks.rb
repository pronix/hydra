class RenameStateInTasks < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :state, :workflow_state

  end

  def self.down
    rename_column :tasks, :workflow_state, :state
  end
end
