require 'rails_helper'
require 'awesome_print'

RSpec.describe Receipt, :type => :model do

  describe 'Validation' do
    before(:each) do
      @receipt = FactoryGirl.build(:receipt)
    end

    it 'should valid the factory receipt' do
      expect(@receipt).to be_valid
    end

    it 'should be invalid object include errors' do
      @receipt.receipt_id = nil
      expect(@receipt).to_not be_valid
    end

    it 'should be invalid if uniqueness is not given' do
      r2 = Receipt.create(receipt_id: 12345, :date => '2014-02-01', member_id: 1233)
      expect(@receipt).to_not be_valid
    end

    it 'should be valid if uniqueness is given' do
      r2 = Receipt.create(receipt_id: 12346, :date => '2014-02-01', member_id: 1233)
      expect(@receipt).to be_valid
    end

  end

  describe 'Methods' do
    before(:each) do
      @receipt = FactoryGirl.build(:receipt)
    end

    it 'should get the right amount in the total sum' do
      @receipt.items << ReceiptItem.create(amount: 33, donation_id: 123)
      @receipt.items << ReceiptItem.create(amount: 33, donation_id: 123)
      expect(@receipt.total).to eql(66)
    end
  end

end
