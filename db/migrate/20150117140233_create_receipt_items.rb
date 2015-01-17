class CreateReceiptItems < ActiveRecord::Migration
  def change
    create_table :receipt_items do |t|
      t.references :receipt, index: true
      t.references :DonationType, index: true
      t.integer :amount

      t.timestamps null: false
    end
    add_foreign_key :receipt_items, :receipts
    add_foreign_key :receipt_items, :DonationTypes
  end
end
