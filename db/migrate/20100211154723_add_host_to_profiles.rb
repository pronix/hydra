class AddHostToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :host, :string, :null => false
    add_index :profiles, [:user_id, :host]
  end

  def self.down
    remove_column :profiles, :host
  end
end
