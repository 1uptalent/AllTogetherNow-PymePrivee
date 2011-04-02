class AddValidityDateRangeToSaleItems < ActiveRecord::Migration
  def self.up
    add_column :sale_items, :valid_from,  :date
    add_column :sale_items, :valid_until, :date
    
    puts SaleItem.where("valid_from is null or valid_until is null").
                  update_all(:valid_from => Date.today.to_date, :valid_until => 1.year.from_now.to_date)
  end

  def self.down
    remove_column :sale_items, :valid_until
    remove_column :sale_items, :valid_from
  end
end