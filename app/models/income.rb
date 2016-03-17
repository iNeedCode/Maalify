class Income < ActiveRecord::Base

# Assoziations
  belongs_to :member

# Validations
  validates_presence_of :amount, :starting_date
  validate :newly_added_income_is_also_the_newest?

# Methods
  def recalculate_budget
    member.budgets.all.each do |b|
      b.calculate_budget if b.budget_based_donation?
      b.save
    end
  end

  def before_date(_date = self.starting_date)
    last = Income.where("member_id = ? AND starting_date < ?",self.member_id, _date).order("starting_date ASC").last
    last.nil? ? Income.new(amount: 0) : last
  end

  def self.list_all_incomes_between_dates(start_date, end_date, members = nil)
    if members.nil?
      Income.where("? <= starting_date AND ? >= starting_date", start_date, end_date).order(starting_date: :asc)
    else
      Income.joins(:member).where("? <= starting_date AND ? >= starting_date AND member_id IN (?)", start_date, end_date, members).order(starting_date: :asc)
    end
  end

  private

  def newly_added_income_is_also_the_newest?
    latest_income_date = Income.where(member: member_id).maximum(:starting_date)
    return true if latest_income_date.nil?
    if !latest_income_date.nil? && latest_income_date >= starting_date
      errors.add(:income, I18n.t('income.error.newly_added_income_is_also_the_newest', name: member.full_name))
    end
  end

end
