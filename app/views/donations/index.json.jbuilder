json.array!(@donations) do |donation|
  json.extract! donation, :id, :name, :budget, :minimum_budget, :formula, :organization
  json.url donation_url(donation, format: :json)
end
