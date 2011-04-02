class CreateSaleItems < ActiveRecord::Migration
  def self.up
    create_table :sale_items do |t|
      t.string :name
      t.text :description
      t.decimal :total_cost, :precision => 10, :scale => 2
      t.decimal :price, :precision => 10, :scale => 2
      t.references :shop

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_items
  end
end
