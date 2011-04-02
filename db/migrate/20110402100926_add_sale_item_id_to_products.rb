class AddSaleItemIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :sale_item_id, :integer
  end

  def self.down
    remove_column :products, :sale_item_id
  end
end