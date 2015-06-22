class Donation < ActiveRecord::Base

# Assoziations
	has_many :receipt_items
	has_many :budgets
	has_many :members, through: :budgets

# Validations
	validates :name, uniqueness: true
	validates :name, presence: true
	validates :organization, inclusion: { in: %w(Khuddam Atfal  Ansar All Lajna Nasirat),
														 message: "'%{value}' is not a valid organization" }, allow_nil: false

end
