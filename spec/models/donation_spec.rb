require 'rails_helper'

RSpec.describe Donation, :type => :model do

  before(:each) do
    @donation = FactoryGirl.build(:majlis_khuddam_donation)
  end

  it 'should be valid' do
    expect(@donation).to be_valid
  end

  it 'should be invalid if name not exist' do
    @donation.name = nil
    expect(@donation).to_not be_valid
  end

  it 'should be invalid if name is not unique' do
    @donation.save
    donation = FactoryGirl.build(:majlis_khuddam_donation)
    expect(donation).to_not be_valid
  end

end
