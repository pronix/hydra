class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string  :name
      t.string  :login
      t.string  :password

      t.timestamps
    end
    add_index :profiles, :user_id
  end

  def self.down
    drop_table :profiles
    remove_index :profiles, :user_id
  end
end
