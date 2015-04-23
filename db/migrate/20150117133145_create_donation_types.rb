class CreateDonationTypes < ActiveRecord::Migration
  def change
    create_table :donation_types do |t|
      t.date :start_date
      t.string :name
      t.date :end_date
      t.string :donation_type

      t.timestamps null: false
    end
    add_index :donation_types, :name, unique: true
  end
end
