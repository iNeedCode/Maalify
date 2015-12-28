class CreateReceiptItems < ActiveRecord::Migration
  def change
    create_table :receipt_items do |t|
      t.references :receipt, index: true
      t.references :donation, index: true
      t.integer :amount

      t.timestamps null: false
    end
    add_foreign_key :receipt_items, :receipts, column: :receipt_id, primary_key: 'receipt_id'
    add_foreign_key :receipt_items, :donations, column: :donation_id, primary_key: 'id'
  end
end
