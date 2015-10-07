class Income < ActiveRecord::Base

# Assoziations
  belongs_to :member

# Validations
  validates_presence_of :amount, :starting_date
  validate :newly_added_income_is_also_the_newest?

# Callbacks
# TODO: http://ruby-journal.com/how-to-track-changes-with-after-callbacks-in-rails-3-or-newer/
#after_create :calculate_budget

# Methods
  def calculate_budget
    member.budgets.all.each { |b| b.calculate_budget }
  end

private

  def newly_added_income_is_also_the_newest?
    latest_income_date = Income.where(member: member_id).maximum(:starting_date)
    return true if latest_income_date.nil?
    if !latest_income_date.nil? && latest_income_date >= starting_date
      errors.add(:income, "newest income should be also the latest income of the member '#{member.full_name}''")
    end
  end

end
