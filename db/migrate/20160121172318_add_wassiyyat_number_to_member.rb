class AddWassiyyatNumberToMember < ActiveRecord::Migration
  def change
    add_column :members, :wassiyyat_number, :string
  end
end
