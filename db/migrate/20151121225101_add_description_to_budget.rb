class AddDescriptionToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :description, :string
  end
end
