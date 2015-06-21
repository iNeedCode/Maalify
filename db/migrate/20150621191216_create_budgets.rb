class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :title
      t.integer :promise
      t.date :start_date
      t.date :end_date
      t.references :member, index: true
      t.references :donation, index: true

      t.timestamps null: false
    end
    add_foreign_key :budgets, :members
    add_foreign_key :budgets, :donations
  end
end
