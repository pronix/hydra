class CreateProxies < ActiveRecord::Migration
  def self.up
    create_table :proxies do |t|
      t.integer :user_id # пользователь
      t.string  :address # ip adress
      t.string  :country # страна
      t.string  :state   # состояние прокси
      t.timestamps
    end
    add_index :proxies, :user_id
    add_index :proxies, :state
  end

  def self.down
    drop_table :proxies
    remove_index :proxies, :user_id
    remove_index :proxies, :state
  end
end
