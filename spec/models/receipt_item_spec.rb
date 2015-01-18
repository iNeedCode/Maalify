require 'rails_helper'

RSpec.describe ReceiptItem, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__} as"
	before(:each) { @ri = ReceiptItem.new(amount: 2)  }

  subject { @ri }

  it "Validate" do
    expect(@ri.amount).to match 2
    # @ri.should have(1).error_on(:amount)
  end

end
