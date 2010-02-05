class AddNotificationEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notification_email, :string
  end

  def self.down
    remove_column :users, :notification_email
  end
end
