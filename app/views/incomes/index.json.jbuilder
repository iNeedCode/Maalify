json.array!(@incomes) do |income|
  json.extract! income, :id, :amount, :starting_date, :member_id
  json.url income_url(income, format: :json)
end
