require 'smarter_csv'
class Member < ActiveRecord::Base

# Assoziations
  has_many :incomes, -> { order "starting_date ASC" }
  has_many :receipts
  has_many :budgets
  has_many :donations, through: :budgets

# Validations
  validates_presence_of :first_name, :last_name, :date_of_birth, :aims_id, :gender
  validates_uniqueness_of :aims_id
  validate :at_least_one_communication_chanel_is_given
  validates :email, allow_blank: true, format: {with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/}
  validates :gender, inclusion: {in: %w(male female),
                                 message: "'%{value}' is not a valid Gender"}, allow_nil: false

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

    if gender == "male"
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

    elsif gender == 'female'
      new_year_of_lajna_begins = Date.parse("01-11-#{Date.today.year}")
      day_before_lajna_year_begins = Date.parse("31-10-#{Date.today.year}")

      if age < 7 then
        return 'Kind'
      elsif age(day_before_lajna_year_begins) >= 15
        return 'Lajna'
      elsif age >= 7 && age(new_year_of_lajna_begins) <= 15
        return 'Nasirat'
      end

    end

  end

  def list_of_possible_donation_types
    Budget.where(member_id: self.id).order(:end_date).map(&:donation).uniq
  end

  def list_available_budgets
    all_budget = Budget.select(:start_date, :end_date, :title, :donation_id).distinct(:title)
    budgets_of_member_title = budgets_of_member.map(&:title)
    budget_from_same_organization = all_budget.select do |budget|
      if (budget.donation.organization == self.tanzeem or budget.donation.organization == "all") and !budgets_of_member_title.include?(budget.title)
        budget
      end
    end
    budget_from_same_organization
  end

  def budgets_of_member
    Budget.where(member: self)
  end

  def self.import(file)
    khuddam_de_mapping = {:"\"jamaat_id\"" => :aims_id,       :"\"vorname\"" => :first_name,
                          :"\"familien_name\"" => :last_name, :"\"geburtsdatum\"" => :date_of_birth,
                          :"\"straße\"" => :street,           :"\"plz\"" => :plz,
                          :"\"stadt\"" => :city,              :"\"e_mail\"" => :email,
                          :"\"handy\"" => :mobile_no,         :"\"tanziem\"" => :gender,
                          :"\"hausnr\"" => :hausnr,           :"\"festnetz\"" => :landline}

    lines = SmarterCSV.process(file.path, options= {col_sep: ';', force_simple_split: true, quote_char: '"',
                                                    remove_unmapped_keys: true, key_mapping: khuddam_de_mapping})

    imported = 0
    lines.each do |line|
      member_hash = line.map { |k, str| [k, str.delete('\\"')] }.to_h
      member = find_by_aims_id(line[:aims_id].delete('\\"')) || new

      unless member_hash[:straße].nil?
        member_hash[:straße] << " #{member_hash[:hausnr]}" unless member_hash[:hausnr].empty?
      end

      member_hash.delete(:hausnr)
      member.attributes = member_hash

      if (member_hash[:gender] == 'Tifl' || member_hash[:gender] == 'Khadim')
        member.gender = 'male'
      else
        member.gender = 'female'
      end

      member.date_of_birth = nil if (member_hash[:date_of_birth] == '01.01.1970')

      # ap "----------------------------------------------------------------------"
      # ap member
      # ap member.errors.to_s
      # ap "----------------------------------------------------------------------"

      member.save
      imported += 1 if member.valid?
    end
    imported
  end

  private

  def at_least_one_communication_chanel_is_given
    if (email.nil? && landline.nil? && mobile_no.nil?)
      errors.add(:member, "You have to specify at least one communication chanel")
    end
  end

end
