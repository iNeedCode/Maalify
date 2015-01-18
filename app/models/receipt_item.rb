class ReceiptItem < ActiveRecord::Base

# Assoziations
  belongs_to :receipt
  belongs_to :donation

# Validations
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :receipt_present
  validate :donation_type_present

private
	def receipt_present
		if receipt.nil?
			errors.add(:receipt, "is not valid or is not active.")
		end
	end

	def donation_type_present
		if donation.nil?
			errors.add(:donation, "is not valid or is not active.")
		end
	end

end
