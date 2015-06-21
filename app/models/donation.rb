class Donation < ActiveRecord::Base

# Assoziations
	has_many :receipt_items
	has_many :budgets
	has_many :members, through: :budgets

# Validations
	validates :name, uniqueness: true
	validates :name, presence: true

end
