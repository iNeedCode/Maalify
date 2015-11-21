class AddNonePayerToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :none_payer, :boolean
  end
end
