class AddCountryCodeToProxies < ActiveRecord::Migration
  def self.up
    add_column :proxies, :country_code, :string
  end

  def self.down
    remove_column :proxies, :country_code
  end
end
