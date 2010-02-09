class DeleteUserFiles < ActiveRecord::Migration
    def self.down
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

  def self.up
    drop_table :user_files

  end
end
