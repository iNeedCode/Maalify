class Member < ActiveRecord::Base

# Assoziations
	has_many :incomes
	has_many :receipts

# Methods
	def full_name
		"#{last_name}, #{first_name}"
	end

	def current_income
		incomes.order(starting_date: :desc).first
	end

	def age
		now = Time.now.utc.to_date
		now.year - date_of_birth.year - (date_of_birth.to_date.change(:year => now.year) > now ? 1 : 0)
	end

end
