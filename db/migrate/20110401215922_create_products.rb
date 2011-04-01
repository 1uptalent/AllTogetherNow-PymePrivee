class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :cost, :precision => 10, :scale => 2
      t.decimal :tax,  :precision => 5,  :scale => 3
      t.references :shop

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
