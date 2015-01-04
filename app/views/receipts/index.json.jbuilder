json.array!(@receipts) do |receipt|
  json.extract! receipt, :id, :receipt_id, :date, :member_id
  json.url receipt_url(receipt, format: :json)
end
