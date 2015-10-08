require 'awesome_print'
require 'rails_helper'

RSpec.describe ReceiptItem, :type => :model do

  describe 'Validations' do

    before(:each) do
      @receipt_item = FactoryGirl.build(:receipt_item)
    end

    it "should validate if the required fields are filled" do
      expect(@receipt_item).to be_valid
    end

    it "should fails if the required fields are filled" do
      @receipt_item.amount = nil
      expect(@receipt_item).to_not be_valid
    end

    it "should fails if assocation 'donation' are missing with a error messsage" do
      @receipt_item.donation = nil
      expect(@receipt_item).to_not be_valid
      expect(@receipt_item.errors[:donation]).to eq(["No donation is aviable to add this receipt item."])
    end

    it "should fails if assocation 'receipt' are missing with a error messsage" do
      @receipt_item.receipt = nil
      expect(@receipt_item).to_not be_valid
      expect(@receipt_item.errors[:receipt]).to eq(["No receipt is available to add the receipt item."])
    end

  end

  describe 'Amount logic' do

    before(:each) do
      @receipt_item = FactoryGirl.build(:receipt_item)
    end

    it "should fails if amount is 0 or less" do
      @receipt_item.amount = 0
      expect(@receipt_item).to_not be_valid
      @receipt_item.amount = 10
      expect(@receipt_item).to be_valid
      @receipt_item.amount = -10
      expect(@receipt_item).to_not be_valid
    end

    it "should pass only integer values for amount" do
      @receipt_item.amount = 10.5
      expect(@receipt_item).to_not be_valid
    end

  end

end
