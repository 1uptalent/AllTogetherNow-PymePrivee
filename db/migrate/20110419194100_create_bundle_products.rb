class CreateBundleProducts < ActiveRecord::Migration
  def self.up
    create_table :bundle_products do |t|
      t.references :bundle
      t.references :product
      t.timestamps
    end
  end

  def self.down
    drop_table :bundle_products
  end
end
