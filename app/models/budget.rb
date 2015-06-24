class Budget < ActiveRecord::Base

# Assoziations
  belongs_to :member
  belongs_to :donation

# Validations
  validates_presence_of :title, :donation, :member, :start_date, :end_date
  validate :validate_income_before_starting_of_budget_date_exist, if: :budget_based_donation?

# Callbacks
  after_create :calculate_budget

# Methods
  def calculate_budget
    if !donation.budget
      self.promise = donation.minimum_budget.to_i
    else
      incomes = get_all_incomes_for_budget_duration
      calculator = Dentaku::Calculator.new
      total_budget = 0
      total_days_of_budget = (end_date - start_date+1).to_f

      #debugger
      if incomes.size == 1
        total_budget = calculator.evaluate("#{donation.formula} * #{incomes.first.amount}").to_i
      else
        incomes.size > 1
        incomes.each_with_index do |inc, i|
          next_income_date = incomes[i+1].nil? ? end_date : incomes[i+1].starting_date
          if start_date > inc.starting_date
            start_date_actual = start_date
          else
            start_date_actual = inc.starting_date
          end
          days_diff = (next_income_date - start_date_actual).to_f
          total_budget += calculator.evaluate("#{inc.amount} * #{donation.formula} / #{total_days_of_budget} * #{days_diff}").to_i
        end

      end

      total_budget = donation.minimum_budget if total_budget < donation.minimum_budget
      self.promise = total_budget
    end
    save
  end

  def get_all_incomes_for_budget_duration
    incomes_during_budget_range = member.incomes.select do |inc|
      start_date <= inc.starting_date && inc.starting_date <= end_date
    end

    smallest_date = incomes_during_budget_range.map(&:starting_date).min
    if smallest_date.nil? || smallest_date >= start_date
      latest_income_before_start_date = member.incomes.select { |inc| inc.starting_date < start_date }.max
      incomes_during_budget_range << latest_income_before_start_date
    end
    incomes_during_budget_range.sort_by &:starting_date
  end

  private

  def budget_based_donation?
    donation.budget?
  end

  def validate_income_before_starting_of_budget_date_exist
    member.incomes.each do |income|
      return true if income.starting_date <= self.start_date
    end
    errors.add(:member, "no income of member before starting budget date")
  end


end
