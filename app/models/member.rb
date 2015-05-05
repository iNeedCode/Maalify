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

  def tanzeem
    if age < 7 then
      'Kind'
    elsif age >= 7 && age <= 15
      'Tifl'
    elsif age > 15 && age < 40
      'Khadim'
    elsif age >= 40
      'Nasir'
    end

  end

end
