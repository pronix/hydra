class ChangeColumnDownloadingFiles < ActiveRecord::Migration
  def self.up
    remove_column :downloading_files, :gid
    add_column :downloading_files, :gid, :string, :null => true
    add_column :downloading_files, :options, :text
  end

  def self.down
    remove_column :downloading_files, :gid
    remove_column :downloading_files, :options
    add_column :downloading_files, :gid, :string, :null => false
  end
end
