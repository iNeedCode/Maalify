FactoryGirl.define do
  factory :receipt do
    receipt_id "12345"
    date "2015-01-04"
    association :member, factory: :member
  end

end
