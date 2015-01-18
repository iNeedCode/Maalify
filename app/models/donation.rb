class Donation < ActiveRecord::Base

# Assoziations
	has_many :receipt_items

# Validations
	validates :name, uniqueness: true
	validates :name, presence: true

end
