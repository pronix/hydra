class AddCountTasksAndTaskToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_tasks,    :integer
    add_column :users, :completed_tasks, :integer
  end

  def self.down

    remove_column :users, :active_tasks
    remove_column :users, :completed_tasks

  end
end
