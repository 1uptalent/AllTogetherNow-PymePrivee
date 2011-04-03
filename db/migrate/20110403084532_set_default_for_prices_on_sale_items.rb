class SetDefaultForPricesOnSaleItems < ActiveRecord::Migration
  def self.up
    change_column_default :sale_items, :total_cost, 0.0
    change_column_default :sale_items, :price, 0.0
    
    SaleItem.where(:total_cost => nil).update_all(:total_cost => 0)
    SaleItem.where(:price => nil).update_all(:price => 0)
  end

  def self.down
    change_column_default :sale_items, :price, nil
    change_column_default :sale_items, :total_cost, nil
  end
end