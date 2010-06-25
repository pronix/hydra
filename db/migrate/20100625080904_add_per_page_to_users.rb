class AddPerPageToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_per_page, :integer, :default => 100
    User.update_all :user_per_page => 100
  end

  def self.down
    remove_column :users, :user_per_page
  end
end
