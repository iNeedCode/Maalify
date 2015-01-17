class Receipt < ActiveRecord::Base

# Assoziations
  belongs_to :member
	has_many :items, class_name: 'ReceiptItem', dependent: :destroy

# Validations
	validates_associated :items, presence: true
	validates :receipt_id, uniqueness: true


# Methods
  def total
  	sum = 0
  	items.collect { |li| li.amount.present? ? sum += li.amount : 0 }
  	sum
  end
end
