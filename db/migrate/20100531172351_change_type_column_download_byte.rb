class ChangeTypeColumnDownloadByte < ActiveRecord::Migration
  def self.up
    change_column :downloading_files, :total_length, :string
    change_column :downloading_files, :completed_length, :string
    change_column :downloading_files, :upload_length, :string
  end

  def self.down
    change_column :downloading_files, :total_length, :integer
    change_column :downloading_files, :completed_length, :integer
    change_column :downloading_files, :upload_length, :integer
  end
end
