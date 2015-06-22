FactoryGirl.define do

  factory :donation do
    budget true
    organization 'Khuddam'
  end

  factory :majlis_khuddam_donation, parent: :donation do
    name 'Majlis'
    formula '0.01*12'
    minimum_budget 36
  end

  factory :ijtema_khuddam_donation, parent: :donation do
    name 'Majlis'
    formula '0.025'
    minimum_budget 24
  end

  factory :ishaat_khuddam_donation, parent: :donation do
    name 'Ishaat'
    budget false
    formula ''
    organization 'Khuddam'
    minimum_budget 3
  end

end
