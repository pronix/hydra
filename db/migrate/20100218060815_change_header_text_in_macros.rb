class ChangeHeaderTextInMacros < ActiveRecord::Migration
  def self.up
    remove_column :macros, :header_text
    add_column :macros, :header_text, :text
  end

  def self.down
    remove_column :macros, :header_text
    add_column :macros, :header_text, :string
  end
end
