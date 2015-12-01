class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.integer :amount
      t.date :starting_date
      t.references :member, index: true

      t.timestamps null: false
    end
    add_foreign_key :incomes, :members
  end
end
