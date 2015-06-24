require 'rails_helper'

RSpec.describe Income, :type => :model do

  before(:each) do
    member = FactoryGirl.create(:member)
    @income = FactoryGirl.create(:income, member: member)
  end

  it 'should validates if income is valid' do
    expect(@income).to be_valid
  end

  it 'should not validates if income is invalid' do
    @income.amount = nil
    @income.starting_date = nil
    expect(@income).to_not be_valid
  end

end
