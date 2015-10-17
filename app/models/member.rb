class Member < ActiveRecord::Base

# Assoziations
  has_many :incomes, -> { order "starting_date ASC" }
  has_many :receipts
  has_many :budgets
  has_many :donations, through: :budgets

# Validations
  validates_presence_of :first_name, :last_name, :date_of_birth, :aims_id
  validates_uniqueness_of :aims_id
  validate :at_least_one_communication_chanel_is_given

# Methods
  def full_name
    "#{last_name}, #{first_name}"
  end

  def current_income
    incomes.order(starting_date: :desc).first
  end

  def oldest_income
    incomes.order(starting_date: :asc).first
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
      return 'Ansar'
    elsif age(day_before_khuddam_year_begins) >= 15 && age(day_before_ansar_year_begins) <= 40
      return 'Khuddam'
    elsif age >= 7 && age(new_year_of_khuddam_begins) <= 15
      return 'Atfal'
    end
  end

  def list_of_possible_donation_types
    Budget.where(member_id: self.id).order(:end_date).map(&:donation)
  end

  private
  def at_least_one_communication_chanel_is_given
    if (email.nil? && landline.nil? && mobile_no.nil?)
      errors.add(:member, "You have to specify at least one communication chanel")
    end
  end

end

