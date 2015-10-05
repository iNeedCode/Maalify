class Budget < ActiveRecord::Base

# Assoziations
  belongs_to :member
  belongs_to :donation

# Validations
  validates_presence_of :title, :donation, :member, :start_date, :end_date
  validate :validate_income_before_starting_of_budget_date_exist, if: :budget_based_donation?
  validate :no_budget_range_from_the_same_donation_type_is_avaiable
  validate :start_date_before_end_date?
  validates :promise, numericality: {only_integer: true, greater_than: -1}
  validates :rest_promise_from_past_budget, numericality: {only_integer: true, greater_than: -1}

# Callbacks
  after_create :calculate_budget, :transfer_old_remaining_promise_to_current_budget

# Methods

# Public: It is called immediatly after creating (callback) a budget model and it's
#         calculating the budget "promise" (column) based on "donation formula"
#         and income of the member.
#
# Returns:
#         true or false
  def calculate_budget
    if !donation.budget
      self.promise = donation.minimum_budget.to_i
    else
      incomes = get_all_incomes_for_budget_duration
      calculator = Dentaku::Calculator.new
      total_budget = 0
      total_days_of_budget = (end_date - start_date+1).to_f

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
  end

# Public: It is called immediatly after creating (callback) a budget model and it's
#         transfering all old remaing promises from the last budget into the newly
#         created budget model in the "rest_promise_from_past_budget".
#
# Returns true or false.
  def transfer_old_remaining_promise_to_current_budget
    budgets = get_all_budget_from_the_same_donation_type_before_current_budget
    return self.rest_promise_from_past_budget = 0 if budgets.nil?
    rest = 0
    unless budgets.nil?
      # debugger
      budgets.each { |b| rest += b.remainingPromiseCurrentBudget }
    end
    self.rest_promise_from_past_budget = rest.abs
    # save
  end

# Public: Get all incomes of a member from the budget period.
#
# Examples
#
#   budget.get_all_incomes_for_budget_duration
#   # => [Income,Income]
#
# Returns:
#         incomes sorted by starting date
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

# Public: Get all receipt items from the budget period for all members.
# Examples
#
#   budget.getAllReceiptsItemsfromBudgetPeriod
#   # => [ReceiptItem,ReceiptItem]
#
# Returns all receipt items in the budget period
  def getAllReceiptsItemsfromBudgetPeriod
    all_receipts_in_period = Receipt.where(date: self.start_date..self.end_date)
    all_receipt_items_in_period_for_budget_donation = []

    all_receipts_in_period.each do |receipt|
      receipt.items.each do |ri|
        if ri.donation == self.donation
          all_receipt_items_in_period_for_budget_donation << ri
        end
      end
    end

    all_receipt_items_in_period_for_budget_donation
  end

# Public: Get all receipt items from the budget period for A SPECIFIC member.
#
# member  - member for the evaluation
#
# Examples
#
#   budget.getAllReceiptsItemsfromBudgetPeriod(_member)
#   # => [ReceiptItem,ReceiptItem]
#
# Returns all receipt items in the budget period for A SPECIFIC member.
  def getAllReceiptsItemsfromBudgetPeriodforMember(_member)
    all_receipt_items_for_all_members = getAllReceiptsItemsfromBudgetPeriod

    all_receipt_items_for_one_member = []
    all_receipt_items_for_all_members.each do |ri|
      if ri.receipt.member == _member
        all_receipt_items_for_one_member << ri
      end

    end
    all_receipt_items_for_one_member
  end

# Public: Get all receipt items from the budget period for A SPECIFIC member.
#
# member  - member for the evaluation
#
# Examples
#
#   budget.getAllReceiptsItemsfromBudgetPeriod(_member)
#   # => [ReceiptItem,ReceiptItem]
#
# Returns all receipt items in the budget period for A SPECIFIC member.
  def remainingPromiseCurrentBudget
    all_receipt_items = getAllReceiptsItemsfromBudgetPeriodforMember(self.member)
    paid = 0
    all_receipt_items.each do |ri|
      paid += ri.amount
    end

    (rest_promise_from_past_budget + promise) - paid
  end

  private

# Public: Get budgets from the same member and donation type before the current budget model.
#
# Returns Array of budget models
  def get_all_budget_from_the_same_donation_type_before_current_budget
    Budget.where('donation_id = ? and end_date < ? and member_id = ?', self.donation_id, self.start_date, self.member_id)
  end

# Public: check if the related "donation" is budget based donation type
#
# Returns true or false
  def budget_based_donation?
    donation.budget
  end

# Public: Validator: for budget based donations. add errors if the member has
#         no income model before the budget ist starting.
#
# Returns ?
  def validate_income_before_starting_of_budget_date_exist
    member.incomes.each do |income|
      return true if income.starting_date <= self.start_date
    end
    errors.add(:member, "no income of member before starting budget date")
  end

  def no_budget_range_from_the_same_donation_type_is_avaiable
    all_budgets = Budget.where(donation: self.donation)
    return true if all_budgets.nil? || all_budgets.empty?
    already_exist = all_budgets.select do |b|
      (b.start_date > start_date && b.end_date < end_date) ||
          ((b.start_date..b.end_date).to_a.include? start_date) ||
          ((b.start_date..b.end_date).to_a.include? end_date)
    end
    if !already_exist.nil? && !already_exist.empty?
      errors.add(:budget, "budget time range already exists for #{self.donation.name}")
    end
  end

# Public: Validator: for checking the "start_date" of the budget is not setups after the "end_date"
#
# Returns ?
  def start_date_before_end_date?
    if start_date >= end_date
      errors.add(:budget, "your start date (#{start_date}) is starting after your end date (#{end_date})")
    end
  end
end
