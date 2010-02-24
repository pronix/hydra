class CreateListScreens < ActiveRecord::Migration
  def self.up
    create_table :list_screens do |t|
      t.integer :task_id
      t.text :links
      t.integer :screen_id
      t.timestamps
    end
    add_index :list_screens, :task_id
  end

  def self.down
    drop_table :list_screens
  end
end
