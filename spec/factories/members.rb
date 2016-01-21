FactoryGirl.define do
  factory :member do
    gender "male"
    last_name "Mustermann"
    first_name "Max"
    aims_id "12345"
    wassiyyat true
    wassiyyat_number Random.rand(100000).to_s
    date_of_birth "1990-01-01"
    street "Musterstrasse 100"
    city "Musterstadt"
    plz 12345
    mobile_no "0177 1234567"
    landline "01234 12323"
    email "max@example.com"
    occupation "Angesteller"
  end

end
