class CreateTaskCovers < ActiveRecord::Migration
  def self.up
    create_table :task_covers do |t|
      t.integer :task_id
      t.text :links
      t.integer :cover_id
    end
    add_index :task_covers, :task_id
  end

  def self.down
    drop_table :task_covers
  end
end
