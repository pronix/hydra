class CreateJobLoggings < ActiveRecord::Migration
  def self.up
    create_table :job_loggings do |t|
      t.integer  :task_id
      t.string   :job
      t.datetime :startup
      t.datetime :stop_time
      t.text     :comment
    end
    add_index :job_loggings, [:task_id, :job]
  end

  def self.down
    drop_table :job_loggings
    remove_index :job_loggings, [:task_id, :job]
  end
end
