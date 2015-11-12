require 'rails_helper'
require 'awesome_print'

RSpec.describe Receipt, :type => :model do

  describe 'Validation' do
    before(:each) do
      budget = FactoryGirl.create(:budget)
      ri1 = ReceiptItem.create(amount: 100, donation_id: 1, receipt_id: 12345)
      @r1 = Receipt.new(receipt_id: 12345, date: "2015-01-04", member_id: 12345)
      @r1.items << ri1
    end

    it 'should valid the factory receipt' do
      expect(@r1).to be_valid
    end

    it 'should be invalid object include errors' do
      @r1.receipt_id = nil
      expect(@r1).to_not be_valid
      expect(@r1.errors.size).to eql(1)
      expect(@r1.errors[:receipt_id].first).to eql("can't be blank")
    end

    it 'should be invalid if uniqueness of a receipt is not given' do
      @r1.save
      ri2 = ReceiptItem.create(amount: 100, donation_id: 1, receipt_id: 12345)
      r2 = Receipt.new(receipt_id: 12345, date: "2015-01-01", member_id: 12345)
      r2.items << ri2

      expect(@r1).to be_valid
      expect(r2).to_not be_valid
      expect(r2.errors.size).to eql(1)
      expect(r2.errors[:receipt_id].first).to eql("has already been taken")
    end

    it 'should be valid if uniqueness is given' do
      @r1.save
      ri2 = ReceiptItem.create(amount: 100, donation_id: 1, receipt_id: 12345)
      r2 = Receipt.new(receipt_id: 12346, date: "2015-01-01", member_id: 12345)
      r2.items << ri2

      expect(@r1).to be_valid
      expect(r2).to be_valid
    end

  end

  describe 'Receipt Items interaction' do
    before(:each) do
      @receipt = FactoryGirl.build(:receipt)
    end

    it 'should get the right amount in the total sum' do
      @receipt.save
      @receipt.items << ReceiptItem.new(amount: 33, donation_id: 123)
      @receipt.items << ReceiptItem.new(amount: 33, donation_id: 123)
      expect(@receipt.total).to eql(66)
    end
  end

end
