class AddHostnameToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :hostname, :string
  end

  def self.down
    remove_column :shops, :hostname
  end
end