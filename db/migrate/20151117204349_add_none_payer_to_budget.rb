class AddNonePayerToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :add_none_payer, :boolean
  end
end
