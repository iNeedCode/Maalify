class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :title
      t.integer :promise, default: 0
      t.date :start_date
      t.date :end_date
      t.references :member, index: true
      t.references :donation, index: true

      t.timestamps null: false
    end
    add_foreign_key :budgets, :members, column: :member_aims_id
    add_foreign_key :budgets, :donations, column: :donation_id
  end
end
