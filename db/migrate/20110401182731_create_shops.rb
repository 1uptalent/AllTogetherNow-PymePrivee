class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name
      t.text :description
      t.string :address
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
