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

  def age(_date = Time.now.utc.to_date)
    _date.year - date_of_birth.year - (date_of_birth.to_date.change(:year => _date.year) > _date ? 1 : 0)
  end

  def tanzeem
    new_year_of_khuddam_begins = Date.parse("01-11-#{Date.today.year}")
    day_before_khuddam_year_begins = Date.parse("31-10-#{Date.today.year}")
    new_year_of_ansar_begins = Date.parse("01-01-#{Date.today.year}")
    day_before_ansar_year_begins = Date.parse("31-12-#{Date.today.year}")

    if age < 7 then
      return 'Kind'
    elsif age(new_year_of_ansar_begins) >= 40
      return 'Nasir'
    elsif age(day_before_khuddam_year_begins) >= 15 && age(day_before_ansar_year_begins) <= 40
      return 'Khadim'
    elsif age >= 7 && age(new_year_of_khuddam_begins) <= 15
      return 'Tifl'
    end
  end

  def list_of_possible_donation_types
    Donation.where(organization: tanzeem)
  end

end

