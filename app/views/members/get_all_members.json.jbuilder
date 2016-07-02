json.array!(@members) do |member|
  json.extract! member, :id, :tanzeem, :full_name, :aims_id, :wassiyyat
  json.url member_url(member, format: :html)
end
