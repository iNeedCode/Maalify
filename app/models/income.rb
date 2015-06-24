class Income < ActiveRecord::Base

# Assoziations
  belongs_to :member

# Validations
  validates_presence_of :amount, :starting_date
  validate :no_starting_dates

# Callbacks
# TODO: http://ruby-journal.com/how-to-track-changes-with-after-callbacks-in-rails-3-or-newer/
#after_create :calculate_budget

# Methods
  def calculate_budget
    member.budgets.all.each { |b| b.calculate_budget }
  end

private

  def no_starting_dates
    latest_income = Income.where(member: member_id).select{|i|i}.max(&:starting_date)
    return true if latest_income.nil?
    if latest_income.starting_date >= starting_date
      errors.add(:income, "newest income should be also the latest income of the member '#{member.full_name}''")
    end
  end

end
