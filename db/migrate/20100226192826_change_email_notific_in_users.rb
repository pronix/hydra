class ChangeEmailNotificInUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :notification_email
    add_column :users, :notification_email, :boolean, :deafult => false
  end

  def self.down
    remove_column :users, :notification_email
    add_column :users, :notification_email, :string
  end
end
