require 'rails_helper'
require 'awesome_print'

RSpec.describe Budget, :type => :model do

  describe 'General tests for the Budget model' do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @donation = FactoryGirl.create(:majlis_khuddam_donation)
      @income = FactoryGirl.create(:income, member: @member)
      @budget = FactoryGirl.build(:budget, donation: @donation, member: @member)
    end

    it "should not valid if the start_date > end_date" do
      @budget.start_date="2015-05-02"
      @budget.end_date="2014-05-01"
      expect(@budget).to_not be_valid
    end
  end

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

    it "should have a valid Income before budget date starts" do
      Income.create(starting_date: '2015-01-01', amount: 900, member: @member)
      income_before_start = @member.incomes.select { |i| i.starting_date <= @budget.start_date }
      expect(income_before_start.size).to be >= 1
    end

    it "can have multiples incomes during a budget" do
      @member.incomes << Income.new(starting_date: '2015-01-02', amount: 900, member: @member)
      expect(@budget.member.incomes.size).to eq(2)
    end

    it "should fail if there no income before the budget starting data" do
      @member.incomes[0].starting_date = "2015-01-01"
      expect(@budget).to_not be_valid
    end

    it 'should get all incomes which are in between of the start_date and end_date' do
      @member.incomes << [Income.new(starting_date: '2015-01-01', amount: 1200, member: @member),
                          Income.new(starting_date: '2015-04-01', amount: 1400, member: @member)]
      budget = FactoryGirl.create(:budget, donation: @donation, member: @member)
      expect(budget.get_all_incomes_for_budget_duration.size).to eq(3)
    end

  end

  describe 'Budget creating and changing tests' do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @donation = FactoryGirl.create(:majlis_khuddam_donation)
      @income = FactoryGirl.create(:income, member: @member)
      @budget = FactoryGirl.build(:budget, donation: @donation, member: @member)
    end

    it 'should get an adapted promise for income change between the budget range', skip_before: true do
      Member.delete_all
      Donation.delete_all
      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      member.incomes << Income.new(starting_date: '2015-01-01', amount: 1200, member_id: 12345)
      member.incomes << Income.new(starting_date: '2015-03-01', amount: 1000, member_id: 12345)

      budget = FactoryGirl.create(:budget, donation: donation, member: member)
      expect(budget.promise).to eq(123)
    end

    it 'should get mininum_promise if income drops drastically', skip_before: true do
      Member.delete_all
      Donation.delete_all
      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      member.incomes << Income.new(starting_date: '2015-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation, member: member)

      expect(budget.promise).to eq(36)
    end

    it 'should fail if a donation period is already occupied (start_date)', skip_before: true do
      member = FactoryGirl.build(:member)
      donation_ijtema = FactoryGirl.build(:ijtema_khuddam_donation)
      member.incomes << Income.new(starting_date: '2014-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation_ijtema, member: member)
      budget1 = FactoryGirl.build(:budget, start_date: '2014-11-01', end_date: '2015-10-30', donation: donation_ijtema, member: member)

      expect(budget1).to_not be_valid
    end

    it 'should pass with occupied date but other donation type', skip_before: true do
      member = FactoryGirl.build(:member)
      donation_ijtema = FactoryGirl.build(:ijtema_khuddam_donation)
      donation_majlis = FactoryGirl.build(:majlis_khuddam_donation)
      member.incomes << Income.new(starting_date: '2014-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation_ijtema, member: member)
      budget1 = FactoryGirl.build(:budget, start_date: '2014-11-01', end_date: '2015-10-30', donation: donation_majlis, member: member)

      expect(budget1).to be_valid
    end

    it 'should pass with same donation type but other time range', skip_before: true do
      member = FactoryGirl.build(:member)
      donation_ijtema = FactoryGirl.build(:ijtema_khuddam_donation)
      member.incomes << Income.new(starting_date: '2014-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation_ijtema, member: member)
      budget1 = FactoryGirl.build(:budget, start_date: '2014-01-01', end_date: '2014-10-30', donation: donation_ijtema, member: member)

      expect(budget1).to be_valid
    end

    it 'should fail if a donation period is already occupied (end_date)', skip_before: true do
      member = FactoryGirl.build(:member)
      donation_ijtema = FactoryGirl.build(:ijtema_khuddam_donation)
      member.incomes << Income.new(starting_date: '2014-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation_ijtema, member: member)
      budget1 = FactoryGirl.build(:budget, start_date: '2014-01-01', end_date: '2015-10-30', donation: donation_ijtema, member: member)

      expect(budget1).to_not be_valid
    end

    it 'should fail with occupied date with larger span of date than already exists', skip_before: true, focus: true do
      member = FactoryGirl.build(:member)
      donation_ijtema = FactoryGirl.build(:ijtema_khuddam_donation)
      member.incomes << Income.new(starting_date: '2014-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation_ijtema, member: member)
      budget1 = FactoryGirl.build(:budget, start_date: '2014-01-01', end_date: '2016-10-30', donation: donation_ijtema, member: member)

      expect(budget1).to_not be_valid
    end

    # xit 'should take the rest of the last budget into the new/next budget period' do
    #   # rest aus dem vorjahr ins nächste budget in das feld :rest_of_last_budget (noch erstellen) ziehen.
    # end
  end

  describe 'Tests with a none budget based donation types' do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @donation = FactoryGirl.create(:ishaat_khuddam_donation)
      FactoryGirl.create(:income, member: @member)
      @budget = FactoryGirl.build(:budget, donation: @donation, member: @member)
    end

    it "[Majlis Ishaat] should get the minimum_budget of donation set as promise in budget" do
      @budget.save
      expect(@budget.promise).to eq(3)
    end

    it "should be valid if there is no income" do
      @member.incomes.delete_all

      expect(@budget).to be_valid
    end
  end

end
