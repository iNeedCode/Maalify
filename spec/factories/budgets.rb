FactoryGirl.define do
  factory :budget do
    title "MKAD-2014-15"
    start_date "2014-11-01"
    end_date "2015-10-31"
    association :member, factory: :member
    association :donation, factory: :majlis_khuddam_donation
  end

end
