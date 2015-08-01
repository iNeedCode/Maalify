class AddRestPromiseFromPastBudgetToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :rest_promise_from_past_budget, :integer, default: 0
  end
end
