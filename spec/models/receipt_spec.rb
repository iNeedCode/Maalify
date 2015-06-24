require 'rails_helper'

RSpec.describe Receipt, :type => :model do
  before(:each) do
    @receipt = FactoryGirl.build(:receipt)
  end

  it 'should test' do
    expect(@receipt).to be_valid
  end

  it 'should not be valid if not valid' do
    @receipt.receipt_id = nil
    expect(@receipt).to_not be_valid
  end

  it 'should not be valid if uniqueness is brocken' do
    r2 = Receipt.create(receipt_id: 12345, :date => '2014-02-01', member_id: 1233)
    expect(@receipt).to_not be_valid
  end

  it 'should get the right amount in total sum' do
    @receipt.items << ReceiptItem.create(amount: 33, donation_id: 123)
    @receipt.items << ReceiptItem.create(amount: 33, donation_id: 123)
    expect(@receipt.total).to eql(66)
  end
end
