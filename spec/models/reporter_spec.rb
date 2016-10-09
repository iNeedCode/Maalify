require 'awesome_print'
require 'rails_helper'

RSpec.describe Reporter, :type => :model do

  describe 'budget, receipt and member interaction' do
    before(:each) do
      @male1 = FactoryGirl.create(:member)
      @male2 = FactoryGirl.create(:member, aims_id: "98765", wassiyyat_number: Random.rand(100000).to_s)
      @femele1 = FactoryGirl.create(:member, aims_id: "9876a", gender: 'female', wassiyyat_number: Random.rand(100000).to_s)
      income = FactoryGirl.create(:income, member: @member1)
      @donation1 = FactoryGirl.create(:majlis_khuddam_donation)
      @donation2 = FactoryGirl.create(:ijtema_khuddam_donation)
      @budget = FactoryGirl.create(:budget, donation: @donation1, member: @male1)
      FactoryGirl.create(:budget, donation: @donation2, member: @male1)
      FactoryGirl.create(:budget, start_date: "2013-11-01", end_date: "2014-10-31", donation: @donation1, member: @male2)
    end

    xit 'testing the remaining_promise_for_whole_budget_title method for overview of all available budgets' do
      # debugger
      # Donation.delete_all; Member.delete_all; Budget.delete_all
      # @member1 = FactoryGirl.create(:member, aims_id: "43210", wassiyyat_number: "43210")
      # income = FactoryGirl.create(:income, member: @member1)
      # donation1 = FactoryGirl.create(:majlis_khuddam_donation)
      # @budget = FactoryGirl.build(:budget, donation: 1, member: @member1)
      receipt1 = Receipt.new(id: 1, date: '2015-01-01', member: @male1)
      receipt2 = Receipt.new(id: 2, date: '2015-02-01', member: @male1)
      receipt1.items << ReceiptItem.create(id: 1, donation: @donation1, amount: 10, receipt_id: 1)
      receipt2.items << ReceiptItem.create(id: 2, donation: @donation1, amount: 20, receipt_id: 2)
      receipt1.save
      receipt2.save

      # @reporter = Reporter.new({
      #                              :id => 2,
      #                              :name => "Majlis",
      #                              :interval => "14,28",
      #                              :donations => ["1", "2", "3"],
      #                              :tanzeems => ["All"],
      #                              :emails => ["test@gmx.com"],
      #                          })
      # @reporter.valid?

      @reporter = FactoryGirl.build(:reporter)
      # @reporter.save(validate: false)
      ap @reporter.valid?
      ap @reporter.overview

      #
      # member3 = FactoryGirl.create(:member, aims_id: "987653", wassiyyat_number: Random.rand(100000).to_s)
      #
      # budget2 = FactoryGirl.build(:budget, title: 'MKAD-2015-16', start_date: '2015-11-01', end_date: '2016-10-31', donation: donation1, member: @member1)
      #
      # @budget.calculate_budget
      # budget2.calculate_budget
      # @budget.save
      # budget2.save
      #
      # receipt1.save
      # receipt2.save
      #
      # total_budgets = Budget.remaining_promise_for_whole_budget_title
      # expect(total_budgets.first[:title]).to eq("MKAD-2014-15")
      # expect(total_budgets.first[:promise]).to eq(120)
      # expect(total_budgets.first[:rest_promise_from_past_budget]).to eq(0)
      # expect(total_budgets.first[:paid_amount]).to eq(30)
      #
      # budget3 = FactoryGirl.build(:budget, title: 'MKAD-2015-16', start_date: '2015-11-01', end_date: '2016-10-31', donation: donation1, member: member3)
      # budget3.calculate_budget
      # budget3.save
      # budget3.reload
      # budget3.save
      #
      #
      # total_budgets = Budget.remaining_promise_for_whole_budget_title
      # expect(total_budgets.last[:title]).to eq("MKAD-2015-16")
      # expect(total_budgets.last[:promise]).to eq(156)
      # expect(total_budgets.last[:paid_amount]).to eq(30)
      #
      # budget3.save
      # budget3.reload
      # receipt3 = Receipt.new(id: 4, date: '2015-12-01', member: member3)
      # receipt3.items << ReceiptItem.create(id: 3, donation: donation1, amount: 10, receipt_id: 1)
      # receipt3.save
      #
      # total_budgets = Budget.remaining_promise_for_whole_budget_title
      # expect(total_budgets.last[:title]).to eq("MKAD-2015-16")
      # expect(total_budgets.last[:promise]).to eq(156)
      # expect(total_budgets.last[:rest_promise_from_past_budget]).to eq(0)
      # expect(total_budgets.last[:paid_amount]).to eq(40)
      # debugger
      ap "Member: #{Member.count}"
      ap "Donation: #{Donation.count}"
      ap Donation.all
      ap "Receipt: #{Receipt.count}"
      ap ReceiptItem.all
      ap "Budget: #{Budget.count}"
    end

  end
end
