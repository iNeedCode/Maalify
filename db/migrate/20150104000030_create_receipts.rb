class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts, :id => false do |t|
      t.primary_key :receipt_id
      t.date :date
      t.belongs_to :member, index: true
      t.references :member, index: true

      t.timestamps null: false
    end
    add_foreign_key :receipts, :members, column: :member_id, primary_key: 'aims_id'
  end
end
