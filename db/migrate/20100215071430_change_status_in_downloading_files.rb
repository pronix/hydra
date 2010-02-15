class ChangeStatusInDownloadingFiles < ActiveRecord::Migration
  def self.up
    remove_column :downloading_files, :status
    add_column :downloading_files, :status, :string
    add_column :downloading_files, :comment, :string
  end

  def self.down
    remove_column :downloading_files, :status
    remove_column :downloading_files, :comment

    add_column :downloading_files, :status, :boolean
  end
end
