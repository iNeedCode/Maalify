class ReceiptItem < ActiveRecord::Base

# Assoziations
  belongs_to :receipt
  belongs_to :donation

# Validations
  validates :amount, presence: true, numericality: {only_integer: true, greater_than: 0}
  validate :receipt_present, :donation_present

  private
  def receipt_present
    if self.receipt_id.nil?
      errors.add(:receipt, "No receipt is available to add the receipt item.")
    end
  end

  def donation_present
    if self.donation_id.nil?
      errors.add(:donation, "No donation is aviable to add this receipt item.")
    end
  end

end
