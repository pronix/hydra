class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :login, :email, :crypted_password, :password_salt, 
                 :persistence_token, :last_login_ip, :current_login_ip
      
      t.string   :perishable_token, :default => '', :null => false
      t.integer  :login_count, :default => 0, :null => false
      t.datetime :last_request_at, :last_login_at, :current_login_at
      t.boolean  :active, :default => true
      
      t.string   :name
      t.boolean  :admin, :default => false
      
      t.timestamps
    end 
    add_index :users, :login
    add_index :users, :email
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    add_index :users, :perishable_token
  end

  def self.down
    drop_table :users
    remove_index :users, :login
    remove_index :users, :email
    remove_index :users, :persistence_token
    remove_index :users, :last_request_at
    remove_index :users, :perishable_token
  end
end
