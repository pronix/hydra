class CreateUserFiles < ActiveRecord::Migration
  def self.up
    create_table :user_files do |t|
      t.integer :user_id
      t.string  :name
      t.text    :description
      
      # PaperClip
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.datetime :file_updated_at
      
      # STI
      t.string :type
      t.timestamps
    end
    add_index :user_files, :user_id
    add_index :user_files, [:user_id, :type]

  end

  def self.down
    drop_table :user_files
    remove_index :user_files, :user_id
    remove_index :user_files, [:user_id, :type]

  end
end

