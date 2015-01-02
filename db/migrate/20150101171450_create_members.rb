class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members, :id => false do |t|
      t.string :last_name
      t.string :first_name
      t.primary_key :aims_id
      t.boolean :wassiyyat
      t.date :date_of_birth
      t.string :street
      t.string :city
      t.string :email
      t.integer :plz
      t.string :mobile_no
      t.string :landline
      t.string :occupation

      t.timestamps null: false
    end
  end
end
