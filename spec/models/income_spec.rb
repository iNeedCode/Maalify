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

  describe "Tests for the Method 'list_of_possible_donation_types' and 'list_available_budgets'" do

    before(:each) do
      @d1 = Donation.create name: "Majlis Khuddam", budget: true, organization: "Khuddam", formula: '0.01*12'
      @d2 = Donation.create name: "ijtema Khuddam", budget: true, organization: "Khuddam", formula: '0.025'
      @d3 = Donation.create name: "Ishaat Khuddam", budget: false, organization: "Khuddam", formula: '3'
      @member = FactoryGirl.create(:member, aims_id: 888)
      @income1 = Income.create(amount: 1000, starting_date: "2014-01-03", member: @member)
      @b1 = Budget.new(title: "MKAD-14-15 Majlis", start_date: "2014-11-01", end_date: "2015-10-30", member: @member, donation: @d1)
      @b2 = Budget.new(title: "MKAD-14-15 Ijtema", start_date: "2014-11-01", end_date: "2015-10-30", member: @member, donation: @d2)
    end

    it "---------------------- NOT TESTED ---------------------- " do
      # TODO make real test.....
    end

  end
end
