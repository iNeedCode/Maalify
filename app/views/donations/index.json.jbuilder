json.array!(@donations) do |donation|
  json.extract! donation, :id, :start_date, :name, :end_date, :budget, :formula, :organization
  json.url donation_url(donation, format: :json)
end
