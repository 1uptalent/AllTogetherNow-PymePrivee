class CreatePaymentsTable < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.references :user
      t.references :sale_item
      t.string :concept
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :status, :default => "user_requested"
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
