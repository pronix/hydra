class AddPercentageAndSpeedToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :percentage, :float
    add_column :tasks, :speed, :integer
  end

  def self.down
    remove_column :tasks, :speed
    remove_column :tasks, :percentage
  end
end
