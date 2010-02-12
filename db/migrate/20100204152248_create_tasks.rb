class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer   :user_id,      :null => false
      t.integer   :category_id,  :null => false

      t.string    :name
      t.text      :description
      t.string    :state

      t.boolean   :proxy
      t.text      :links

      t.boolean   :use_password, :default => false  #
      t.string    :password                         #

      t.boolean   :add_screens_to_arhive
      t.boolean   :add_covers_to_arhive
      t.boolean   :extracting_files



      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
