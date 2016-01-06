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

    it 'should pass if the budget based donation has no income for member, that should apply the minimum budget', skip_before: true do
      Member.delete_all
      Donation.delete_all
      Income.delete_all

      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      budget = FactoryGirl.create(:budget, donation: donation, member: member)

      expect(budget.promise).to eq(36)
    end

    it 'should calculate the correct promise from no income to income a within a budget period', skip_before: true do
      Member.delete_all;Budget.delete_all;Donation.delete_all;Income.delete_all
      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      FactoryGirl.create(:income, member: member, starting_date: '2015-12-01', amount: 1300)
      budget = FactoryGirl.build(:budget, title: 'Lajna', donation: donation, member: member , start_date: '2015-10-01', end_date: '2016-09-30')

      budget.calculate_budget
      expect(budget.promise).to eq(136)
    end

    it 'should calculate the correct promise for increased income', skip_before: true do
      Member.delete_all;Budget.delete_all;Donation.delete_all;Income.delete_all
      member = FactoryGirl.create(:member)
      donation = FactoryGirl.create(:majlis_khuddam_donation)
      FactoryGirl.create(:income, member: member, starting_date: '2015-01-01', amount: 100)
      FactoryGirl.create(:income, member: member, starting_date: '2015-12-01', amount: 1300)
      budget = FactoryGirl.build(:budget, title: 'Lajna', donation: donation, member: member , start_date: '2015-10-01', end_date: '2016-09-30')

      budget.calculate_budget
      expect(budget.promise).to eq(135)
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

      expect(budget.promise).to eq(50)
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

    it 'should fail with occupied date with larger span of date than already exists', skip_before: true do
      member = FactoryGirl.build(:member)
      donation_ijtema = FactoryGirl.build(:ijtema_khuddam_donation)
      member.incomes << Income.new(starting_date: '2014-01-01', amount: 100, member: member)

      budget = FactoryGirl.create(:budget, donation: donation_ijtema, member: member)
      budget1 = FactoryGirl.build(:budget, start_date: '2014-01-01', end_date: '2016-10-30', donation: donation_ijtema, member: member)

      expect(budget1).to_not be_valid
    end
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

  describe 'budget, receipt and member interaction' do
    before(:each) do
      @member1 = FactoryGirl.create(:member)
      @member2 = FactoryGirl.create(:member, aims_id: "98765")
      income = FactoryGirl.create(:income, member: @member1)
      donation1 = FactoryGirl.create(:majlis_khuddam_donation)
      donation2 = FactoryGirl.create(:ijtema_khuddam_donation)
      @budget = FactoryGirl.create(:budget, donation: donation1, member: @member1)
      FactoryGirl.create(:budget, donation: donation2, member: @member1)
      FactoryGirl.create(:budget, start_date: "2013-11-01", end_date: "2014-10-31", donation: donation1, member: @member2)
    end

    it 'get all receipt items: 1 receipt inside and 1 receipt outside the period and different members' do
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2014-02-01', member: @member2)
      receipt3 = Receipt.new(id: 3, date: '2015-01-02', member: @member1)
      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 10, receipt_id: 1)
      receipt3.items << ReceiptItem.create!(id: 4, donation_id: 1, amount: 10, receipt_id: 1)
      receipt1.items << ReceiptItem.create!(id: 2, donation_id: 2, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 3, donation_id: 1, amount: 10, receipt_id: 1)
      receipt1.save
      receipt2.save

      all_receipt_items_in_period_for_budget_donation = @budget.getAllReceiptsItemsfromBudgetPeriod
      expect(all_receipt_items_in_period_for_budget_donation.size).to be(2)
    end

    it 'get all receipt items: 2 receipts inside in the period and same member' do
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt3 = Receipt.new(id: 3, date: '2015-01-02', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 10, receipt_id: 1)
      receipt3.items << ReceiptItem.create!(id: 3, donation_id: 1, amount: 10, receipt_id: 1)
      receipt1.items << ReceiptItem.create!(id: 4, donation_id: 2, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 2, donation_id: 1, amount: 10, receipt_id: 1)
      receipt1.save
      receipt2.save
      receipt3.save

      all_receipt_items_in_period_for_budget_donation = @budget.getAllReceiptsItemsfromBudgetPeriod
      expect(all_receipt_items_in_period_for_budget_donation.size).to be(3)
    end

    it 'get all receipts for a member in period' do
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt3 = Receipt.new(id: 3, date: '2015-02-01', member: @member2)
      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 11, receipt_id: 1)
      receipt1.items << ReceiptItem.create!(id: 2, donation_id: 2, amount: 12, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 3, donation_id: 2, amount: 13, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 4, donation_id: 1, amount: 14, receipt_id: 1)
      receipt3.items << ReceiptItem.create!(id: 5, donation_id: 1, amount: 15, receipt_id: 1)
      receipt3.items << ReceiptItem.create!(id: 6, donation_id: 1, amount: 16, receipt_id: 1)
      receipt1.save
      receipt2.save
      receipt3.save

      all_receipt_items_in_period_for_budget_donation_for_member = @budget.getAllReceiptsItemsfromBudgetPeriodforMember(@member1)
      expect(all_receipt_items_in_period_for_budget_donation_for_member.size).to be(4)
    end

    it 'should calculate the remaining promise in the current year correctly' do
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 2, donation_id: 1, amount: 20, receipt_id: 2)
      receipt1.save
      receipt2.save

      expect(@budget.promise).to be(120)
      expect(@budget.remainingPromiseCurrentBudget).to be(90)
    end

    it 'should calculate correctly if the payment was higher then the budget itself' do
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 2, donation_id: 1, amount: 120, receipt_id: 2)
      receipt1.save
      receipt2.save

      expect(@budget.promise).to be(120)
      expect(@budget.remainingPromiseCurrentBudget).to be(0)
    end

    it 'should calculate remainng promise and rest promise of last budget period when the payment was higher in the past year',skip_before: true do
      Donation.delete_all; Member.delete_all; Budget.delete_all
      @member1 = FactoryGirl.create(:member, aims_id: "43210")
      income = FactoryGirl.create(:income, member: @member1)
      donation1 = FactoryGirl.create(:majlis_khuddam_donation)
      @budget = FactoryGirl.create(:budget, donation: donation1, member: @member1)
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt1.items << ReceiptItem.create(id: 1, donation: donation1, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create(id: 2, donation: donation1, amount: 120, receipt_id: 2)
      receipt1.save
      receipt2.save

      @budget.save
      @budget.reload
      @budget.calculate_budget
      @budget.save



      budget2 = FactoryGirl.create(:budget, title: 'MKAD-2015-16', start_date: '2015-11-01', end_date: '2016-10-31',
                                   donation: donation1, member: @member1)

      budget2.reload
      budget2.calculate_budget
      budget2.transfer_old_remaining_promise_to_current_budget
      budget2.save

      expect(budget2.remainingPromiseCurrentBudget).to be(120)
    end

    it 'should calculate remainng promise and rest promise of last budget period',skip_before: true do
      Donation.delete_all; Member.delete_all; Budget.delete_all
      @member1 = FactoryGirl.create(:member, aims_id: "43210")
      income = FactoryGirl.create(:income, member: @member1)
      donation1 = FactoryGirl.create(:majlis_khuddam_donation)
      @budget = FactoryGirl.create(:budget, donation: donation1, member: @member1)
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt1.items << ReceiptItem.create(id: 1, donation: donation1, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create(id: 2, donation: donation1, amount: 10, receipt_id: 2)
      receipt1.save
      receipt2.save

      @budget.save
      @budget.reload
      @budget.calculate_budget
      @budget.save



      budget2 = FactoryGirl.create(:budget, title: 'MKAD-2015-16', start_date: '2015-11-01', end_date: '2016-10-31',
                                   donation: donation1, member: @member1)

      budget2.reload
      budget2.calculate_budget
      budget2.transfer_old_remaining_promise_to_current_budget
      budget2.save

      expect(budget2.remainingPromiseCurrentBudget).to be(220)
    end

    it 'testing the remaining_promise_for_whole_budget_title method for overview of all available budgets' do
      Donation.delete_all; Member.delete_all; Budget.delete_all
      @member1 = FactoryGirl.create(:member, aims_id: "43210")
      income = FactoryGirl.create(:income, member: @member1)
      donation1 = FactoryGirl.create(:majlis_khuddam_donation)
      @budget = FactoryGirl.build(:budget, donation: donation1, member: @member1)
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @member1)
      receipt1.items << ReceiptItem.create(id: 1, donation: donation1, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create(id: 2, donation: donation1, amount: 20, receipt_id: 2)

      member3 = FactoryGirl.create(:member, aims_id: "987653")

      budget2 = FactoryGirl.build(:budget, title: 'MKAD-2015-16', start_date: '2015-11-01', end_date: '2016-10-31', donation: donation1, member: @member1)

      @budget.calculate_budget
      budget2.calculate_budget
      @budget.save
      budget2.save

      receipt1.save
      receipt2.save

      total_budgets = Budget.remaining_promise_for_whole_budget_title
      expect(total_budgets.first[:title]).to eq("MKAD-2014-15")
      expect(total_budgets.first[:promise]).to eq(120)
      expect(total_budgets.first[:rest_promise_from_past_budget]).to eq(0)
      expect(total_budgets.first[:paid_amount]).to eq(30)

      budget3 = FactoryGirl.build(:budget, title: 'MKAD-2015-16', start_date: '2015-11-01', end_date: '2016-10-31', donation: donation1, member: member3)
      budget3.calculate_budget
      budget3.save
      budget3.reload
      budget3.save


      total_budgets = Budget.remaining_promise_for_whole_budget_title
      expect(total_budgets.last[:title]).to eq("MKAD-2015-16")
      expect(total_budgets.last[:promise]).to eq(156)
      expect(total_budgets.last[:paid_amount]).to eq(30)

      budget3.save
      budget3.reload
      receipt3 = Receipt.new(id: 4, date: '2015-12-01', member: member3)
      receipt3.items << ReceiptItem.create(id: 3, donation: donation1, amount: 10, receipt_id: 1)
      receipt3.save

      total_budgets = Budget.remaining_promise_for_whole_budget_title
      expect(total_budgets.last[:title]).to eq("MKAD-2015-16")
      expect(total_budgets.last[:promise]).to eq(156)
      expect(total_budgets.last[:rest_promise_from_past_budget]).to eq(0)
      expect(total_budgets.last[:paid_amount]).to eq(40)
    end

    it 'should return distict Budget names of existing budgets in the database' do
      FactoryGirl.create(:budget, donation_id: 1, member: @member2)
      expect(Budget.find_distict_budget_names.size).to eq(1)
      FactoryGirl.create(:budget, title: "other title", donation_id: 2, member: @member2)
      expect(Budget.find_distict_budget_names.size).to eq(2)
      FactoryGirl.create(:budget, start_date: '2016-01-01', end_date: '2016-12-31' , title: "other title 1", donation_id: 2, member: @member1)
      expect(Budget.find_distict_budget_names.size).to eq(3)
      Budget.delete_all
      expect(Budget.find_distict_budget_names.size).to eq(0)
    end

    it 'should calculate the average payment for the remaining promise' do
      receipt1 = Receipt.new(id: 1, date: '2014-11-15', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2014-11-15', member: @member1)

      Timecop.freeze(Date.parse("14-11-2014"))
      expect(@budget.average_payment).to be(10)

      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 20, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 2, donation_id: 1, amount: 20, receipt_id: 2)
      receipt1.save
      receipt2.save

      expect(@budget.promise).to be(120)
      expect(@budget.average_payment).to be(7)
    end

    it 'should calculate the paid amount for the budget from the receipt items' do
      receipt1 = Receipt.new(id: 1, date: '2014-11-15', member: @member1)
      receipt2 = Receipt.new(id: 2, date: '2014-11-15', member: @member1)

      Timecop.freeze(Date.parse("14-11-2014"))
      expect(@budget.average_payment).to be(10)

      expect(@budget.paid_amount).to be(0)
      receipt1.items << ReceiptItem.create!(id: 1, donation_id: 1, amount: 20, receipt_id: 1)
      receipt2.items << ReceiptItem.create!(id: 2, donation_id: 1, amount: 20, receipt_id: 2)
      receipt1.save
      receipt2.save

      expect(@budget.paid_amount).to be(40)
    end

  end
end
