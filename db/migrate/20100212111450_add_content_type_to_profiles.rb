class AddContentTypeToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :content_type_id, :integer
  end

  def self.down
    remove_column :profiles, :content_type_id
  end
end
