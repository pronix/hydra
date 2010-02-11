class AddRenameToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :rename, :boolean
    add_column :tasks, :macro_renaming, :string
    add_column :tasks, :that_rename, :string
    add_column :tasks, :rename_file_name, :string
    add_column :tasks, :rename_text, :string
  end

  def self.down
    remove_column :tasks, :macro_renaming
    remove_column :tasks, :rename
    remove_column :tasks, :that_rename
    remove_column :tasks, :rename_file_name
    remove_column :tasks, :rename_text
  end
end
