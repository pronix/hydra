class RenameStatusInDownloadingFiles < ActiveRecord::Migration
  def self.up
    rename_column :downloading_files, :status, :workflow_state
  end

  def self.down
    rename_column :downloading_files, :workflow_state, :status
  end
end
