json.array!(@budgets) do |budget|
  json.extract! budget, :id, :title, :promise, :start_date, :end_date, :member_id, :donation_id
  json.url budget_url(budget, format: :json)
end
