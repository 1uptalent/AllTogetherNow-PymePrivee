class RenameSaleItemsToBundles < ActiveRecord::Migration
  def self.up
    rename_table :sale_items, :bundles
    rename_column :payments, :sale_item_id, :bundle_id
    rename_column :products, :sale_item_id, :bundle_id
  end

  def self.down
    rename_column :products, :bundle_id, :sale_item_id
    rename_column :payments, :bundle_id, :sale_item_id
    rename_table :bundles, :sale_items
  end
end