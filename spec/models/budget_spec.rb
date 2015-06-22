require 'rails_helper'
require 'awesome_print'

RSpec.describe Budget, :type => :model do

  describe 'Tests with a budget based donation types' do
    before(:each) do
      @member = FactoryGirl.create(:member)
      @donation = FactoryGirl.create(:majlis_khuddam_donation)
      @income = FactoryGirl.create(:income, member: @member)
      @budget = FactoryGirl.create(:budget, donation: @donation, member: @member)
    end

    it "[Majlis Khuddam] should calculation the budget with current income and formula passed into donation" do
      expect(@budget.promise).to eq(120)
    end

    it "[Majlis Khuddam] should use the minimum_budget if the current_income is to less" do
      @income.amount = 100
      @income.save
      @budget.calculate_budget
      expect(@budget.promise).to eq(@donation.minimum_budget)
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
  end

end
