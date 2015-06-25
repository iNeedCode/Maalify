require 'rails_helper'
require 'awesome_print'

RSpec.describe Budget, :type => :model do

  describe 'Tests with a budget based donation types' do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @donation = FactoryGirl.create(:majlis_khuddam_donation)
      @income = FactoryGirl.create(:income, member: @member)
      @budget = FactoryGirl.build(:budget, donation: @donation, member: @member)
    end

    it "[Majlis Khuddam] should calculation the budget with current income and formula passed into donation" do
      @budget.save
      expect(@budget.promise).to eq(120)
    end

    it "[Majlis Khuddam] should use the minimum_budget if the current_income is to low" do
      @budget.save
      @member.incomes.first.amount=100
      @budget.calculate_budget
      expect(@budget.promise).to eq(@donation.minimum_budget)
    end

    it "[Income] should have a valid Income before budget date starts" do
      Income.create(starting_date: '2015-01-01', amount: 900, member: @member)
      income_before_start = @member.incomes.select { |i| i.starting_date <= @budget.start_date }
      expect(income_before_start.size).to be >= 1
    end

    it "[Income] can have multiples incomes during a budget" do
      @member.incomes << Income.new(starting_date: '2015-01-02', amount: 900, member: @member)
      expect(@budget.member.incomes.size).to eq(2)
    end

    it "[Income] should throw an expection if there no income before the budget is starting" do
      @member.incomes[0].starting_date = "2015-01-01"
      expect(@budget).to_not be_valid
    end

    it '[Budget] should get all incomes which are in between of the start_date and end_date' do
      # debugger
      @member.incomes << [Income.new(starting_date: '2015-01-01', amount: 1200, member: @member),
                             Income.new(starting_date: '2015-04-01', amount: 1400, member: @member)]
      budget = FactoryGirl.create(:budget, donation: @donation, member: @member)
      expect(budget.get_all_incomes_for_budget_duration.size).to eq(3)
    end

    it '[Budget] should get an adapted promise for income change between the budget range', focus: true, skip_before: true do
      Member.delete_all
      Donation.delete_all
      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      #income = FactoryGirl.create(:income, member: member)

      member.incomes << Income.new(starting_date: '2015-01-01', amount: 1200, member_id: 12345)
      member.incomes << Income.new(starting_date: '2015-03-01', amount: 1000, member_id: 12345)

      budget = FactoryGirl.create(:budget, donation: donation, member: member)

      expect(budget.promise).to eq(123)
    end

    it '[Budget] should get mininum_promise if income drops drastically', skip_before: true do
      Member.delete_all
      Donation.delete_all
      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      member.incomes << Income.new(starting_date: '2015-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation, member: member)

      expect(budget.promise).to eq(36)
    end
  end

  describe 'Tests with a none budget based donation types' do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @donation = FactoryGirl.create(:ishaat_khuddam_donation)
      FactoryGirl.create(:income, member: @member)
      @budget = FactoryGirl.create(:budget, donation: @donation, member: @member)
    end

    it "[Majlis Ishaat] should get the minimum_budget of donation set as promise in budget" do
      expect(@budget.promise).to eq(3)
    end

    it "[Income] should be valid if there is no income" do
      @member.incomes.delete_all
      expect(@budget).to be_valid
    end
  end

end
