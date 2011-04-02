class AddValidityDateRangeToSaleItems < ActiveRecord::Migration
  def self.up
    add_column :sale_items, :valid_from, :date
    add_column :sale_items, :valid_until, :date
  end

  def self.down
    remove_column :sale_items, :valid_to
    remove_column :sale_items, :valid_until
  end
end