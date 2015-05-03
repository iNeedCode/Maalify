class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.date :start_date
      t.string :name
      t.date :end_date
      t.boolean :budget
      t.string :formula
      t.string :organization

      t.timestamps null: false
    end
    add_index :donations, :name, unique: true
  end
end
