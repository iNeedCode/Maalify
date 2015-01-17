class ReceiptItem < ActiveRecord::Base

# Assoziations
  belongs_to :receipt
  belongs_to :DonationType

# Validations
  validates :amount, presence: true
end
