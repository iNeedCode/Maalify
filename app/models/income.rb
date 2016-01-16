class Income < ActiveRecord::Base

# Assoziations
  belongs_to :member

# Validations
  validates_presence_of :amount, :starting_date
  validate :newly_added_income_is_also_the_newest?

# Methods
  def recalculate_budget
    member.budgets.all.each do |b|
      b.calculate_budget
      b.save
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
