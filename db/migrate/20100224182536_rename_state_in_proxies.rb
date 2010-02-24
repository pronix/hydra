class RenameStateInProxies < ActiveRecord::Migration
  def self.up
    rename_column :proxies, :state, :workflow_state
  end

  def self.down
    rename_column :proxies, :workflow_state, :state
  end
end
