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

  it 'should fail if income attributes are not present' do
    @income.starting_date = nil
    expect(@income).to_not be_valid
    @income.amount = nil
    expect(@income).to_not be_valid
  end

  it 'should add a new income if the income is valid and added after the old income' do
    @income.save
    income = Income.new(starting_date: '2014-01-04', member_id: '12345', amount: 900)
    expect(income).to be_valid
  end

  it 'should fail if newly created income have a starting_date < already persitst incomes' do
    @income.save
    income = Income.create(starting_date: '2014-01-01', member_id: '12345', amount: 900)
    expect(income).to_not be_valid
    expect(income.errors[:income]).to eq(["newest income should be also the latest income of the member '#{income.member.full_name}''"])
  end
end
