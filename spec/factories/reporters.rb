FactoryGirl.define do
  factory :reporter do
    name "MyReport"
    donations %W(1 2)
    tanzeems "MyString"
    interval "28"
    emails { ["lkajsdf@gmail.com"] }
  end
end
