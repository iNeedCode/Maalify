class Budget < ActiveRecord::Base

# Assoziations
  belongs_to :member
  belongs_to :donation

# Validations
  validates_presence_of :title, :donation, :member, :start_date, :end_date

# Callbacks
  after_create :calculate_budget

  def calculate_budget
    unless donation.budget?
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


end
