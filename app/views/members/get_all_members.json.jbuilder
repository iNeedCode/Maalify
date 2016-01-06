json.array!(@members) do |member|
  json.extract! member, :id, :tanzeem, :full_name, :last_name, :first_name, :aims_id, :wassiyyat, :date_of_birth, :street, :city, :plz, :mobile_no, :occupation
  json.url member_url(member, format: :json)
end
