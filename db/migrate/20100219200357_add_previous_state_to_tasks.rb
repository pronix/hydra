class AddPreviousStateToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :previous_state, :string
  end

  def self.down
    remove_column :tasks, :previous_state
  end
end
