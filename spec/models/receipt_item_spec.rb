require 'awesome_print'
require 'rails_helper'

RSpec.describe ReceiptItem, :type => :model do

  describe 'Validations' do

    before(:each) do
      budget = FactoryGirl.create(:budget)
      @ri1 = ReceiptItem.create(amount: 100, donation_id: 1, receipt_id: 12345)
      r1 = Receipt.new(receipt_id: 12345, date: "2015-01-04", member_id: 12345)
      r1.items << @ri1
    end

    it "should validate if the required fields are filled" do
      expect(@ri1).to be_valid
    end

    it "should fails if amount is negativ" do
      @ri1.amount = -1
      expect(@ri1).to_not be_valid
      expect(@ri1.errors[:amount].first).to eql("must be greater than 0")
      expect(@ri1.errors.size).to eql(1)
    end


    it "should fails if amount is nil" do
      @ri1.amount = nil
      expect(@ri1).to_not be_valid
      expect(@ri1.errors[:amount].first).to eql("can't be blank")
      expect(@ri1.errors[:amount][1]).to eql("is not a number")
      expect(@ri1.errors.size).to eql(2)
    end

    it "should fails if assocation 'donation' are missing with a error messsage" do
      @ri1.donation = nil
      expect(@ri1).to_not be_valid
      expect(@ri1.errors[:donation].first).to eq("No donation is aviable to add this receipt item.")
      expect(@ri1.errors.size).to eql(1)
    end

    it "should fails if assocation 'receipt' are missing with a error messsage" do
      @ri1.receipt = nil
      expect(@ri1).to_not be_valid
      expect(@ri1.errors[:receipt].first).to eq("No receipt is available to add the receipt item.")
      expect(@ri1.errors.size).to eql(1)
    end

  end

  describe 'Amount logic' do

    before(:each) do
      budget = FactoryGirl.create(:budget)
      @ri1 = ReceiptItem.create(amount: 100, donation_id: 1, receipt_id: 12345)
      r1 = Receipt.new(receipt_id: 12345, date: "2015-01-04", member_id: 12345)
      r1.items << @ri1
    end

    it "should fails if amount is 0 or less" do
      @ri1.amount = 0
      expect(@ri1).to_not be_valid
      @ri1.amount = 10
      expect(@ri1).to be_valid
      @ri1.amount = -10
      expect(@ri1).to_not be_valid
    end

    it "should pass only integer values for amount" do
      @ri1.amount = 10.5
      expect(@ri1).to_not be_valid
    end

  end

end
