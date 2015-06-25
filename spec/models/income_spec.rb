require 'rails_helper'
require 'awesome_print'

RSpec.describe Income, :type => :model do

  before(:each) do
    Income.delete_all
    @income = FactoryGirl.build(:income)
  end

  it 'should validates if income is valid' do
    expect(@income).to be_valid
  end

  it 'should not validates if income is invalid' do
    @income.amount = nil
    @income.starting_date = nil
    expect(@income).to_not be_valid
  end

  it 'should not validates if newly created income have a starting < already persitst incomes' do
    @income.save
    income = Income.create(starting_date: '2014-01-01', member_id: '12345', amount: 900)
    expect(income).to_not be_valid
  end
end
