class CreateDownloadingFiles < ActiveRecord::Migration
  def self.up
    create_table :downloading_files do |t|
      t.integer :task_id
      t.string  :uri
      t.string  :gid, :null=> false
      t.boolean :status, :default => false

      t.integer :speed,            :default => 0
      t.integer :total_length,     :default => 0
      t.integer :completed_length, :default => 0
      t.integer :upload_length,    :default => 0
      t.timestamps
    end

    add_index :downloading_files, :task_id
    add_index :downloading_files, :gid
    add_index :downloading_files, [:task_id, :gid]

    add_column :tasks, :complete_downloading, :boolean, :default => false
    remove_column :tasks, :gid
  end

  def self.down
    drop_table :downloading_files

    remove_index :downloading_files, :task_id
    remove_index :downloading_files, :gid
    remove_index :downloading_files, [:task_id, :gid]

    remove_column :tasks, :complete_downloading
    add_column :tasks, :gid, :string
  end
end
