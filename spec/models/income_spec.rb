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
    expect(income.errors[:income]).to eq(["Das angelegt Einkommmen muss auch gleichzeit das neueste sein von #{income.member.full_name}"])
  end

  describe "Tests for the Income methods" do

    before(:each) do
      @d1 = Donation.create name: "Majlis Khuddam", budget: true, organization: "Khuddam", formula: '0.01*12'
      @d2 = Donation.create name: "ijtema Khuddam", budget: true, organization: "Khuddam", formula: '0.025'
      @d3 = Donation.create name: "Ishaat Khuddam", budget: false, organization: "Khuddam", formula: '3'
      @member = FactoryGirl.create(:member, aims_id: 888, wassiyyat_number: Random.rand(100000).to_s)
      @member2 = FactoryGirl.create(:member, aims_id: 889, wassiyyat_number: Random.rand(100000).to_s)
      @income1 = Income.create(amount: 1000, starting_date: "2014-01-03", member: @member)
      income2 = Income.create(amount: 1200, starting_date: "2014-09-11", member: @member2)
      @b1 = Budget.create(title: "MKAD-14-15 Majlis", start_date: "2014-11-01", end_date: "2015-10-30", member: @member, donation: @d1)
      @b2 = Budget.create(title: "MKAD-14-15 Ijtema", start_date: "2014-11-01", end_date: "2015-10-30", member: @member, donation: @d2)
    end

    it "should recalculate the budget of member after adding a income" do
      @income1.recalculate_budget
      expect(Budget.find(1).promise).to eql(120)
      expect(Budget.find(2).promise).to eql(25)
      Income.create(amount: 2000, starting_date: "2014-01-05", member: @member)

      @member.reload
      @income1.recalculate_budget
      expect(Budget.find(1).promise).to eql(240)
      expect(Budget.find(2).promise).to eql(50)
    end

    it "should return incomes between to dates without members" do
      income2 = Income.create(amount: 1300, starting_date: "2015-01-01", member: @member)
      expect(Income.list_all_incomes_between_dates('2014-01-03', '2015-05-01').size).to eql(3)
      expect(Income.list_all_incomes_between_dates('2014-01-04', '2015-05-01').size).to eql(2)
      expect(Income.list_all_incomes_between_dates('2014-12-31', '2015-05-01').size).to eql(1)
      expect(Income.list_all_incomes_between_dates('2015-01-01', '2015-05-01').size).to eql(1)
      expect(Income.list_all_incomes_between_dates('2015-01-02', '2015-05-01').size).to eql(0)
    end

    it "should return incomes between to dates with members parameter" do
      income2 = Income.create(amount: 1300, starting_date: "2015-01-01", member: @member)
      expect(Income.list_all_incomes_between_dates('2014-01-03', '2015-05-01', Member.pluck(:aims_id)).size).to eql(3)
      expect(Income.list_all_incomes_between_dates('2014-01-03', '2015-05-01', Member.where(aims_id: 888).map(&:id)).size).to eql(2)
      expect(Income.list_all_incomes_between_dates('2014-01-03', '2015-05-01', Member.where(aims_id: 889).map(&:id)).size).to eql(1)
      expect(Income.list_all_incomes_between_dates('2014-01-03', '2015-05-01', Member.where(aims_id: 1111).map(&:id)).size).to eql(0)
    end

    it "should return the income before the current income" do
      expect(@income1.before_date.amount).to eql(0)

      income2 = Income.create(amount: 1300, starting_date: "2015-01-01", member: @member)
      expect(income2.before_date.amount).to eql(1000)

      income3 = Income.create(amount: 1000, starting_date: "2015-02-01", member: @member)
      expect(income3.before_date.amount).to eql(1300)
    end

  end
end
