class Budget < ActiveRecord::Base

# Assoziations
  belongs_to :member
  belongs_to :donation

# Validations
  validates_presence_of :title, :donation, :member, :start_date, :end_date
  validate :income_before_starting_of_budget_date, if: :budget_based_donation?

# Callbacks
  after_create :calculate_budget

# Methods
  def calculate_budget
    if !donation.budget
      self.promise = donation.minimum_budget.to_i
    else
      calculator = Dentaku::Calculator.new
      computed_promise = calculator.evaluate("#{donation.formula} * #{member.current_income.amount}").to_i

      if computed_promise >= donation.minimum_budget
        self.promise = computed_promise
      else
        self.promise = donation.minimum_budget
      end
    end
    save
  end

private
  def budget_based_donation?
    donation.budget?
  end


  def income_before_starting_of_budget_date
    member.incomes.each do |income|
      return true if income.starting_date <= self.start_date
    end
    errors.add(:member, "no income of member before starting budget date")
  end


end
