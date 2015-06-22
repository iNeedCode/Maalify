FactoryGirl.define do
  factory :income do
    amount 1000
    starting_date "2014-01-03"
    association :member, factory: :member
  end

end
