class AddIndexToReceiptItem < ActiveRecord::Migration
  def change
    add_index :receipts, :receipt_id, :unique => true
    add_index :receipt_items, :amount
  end
end
