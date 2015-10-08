FactoryGirl.define do
  factory :receipt_item do
    amount 100
    association :receipt, factory: :receipt
    association :donation, factory: :majlis_khuddam_donation
  end

end
