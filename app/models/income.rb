class Income < ActiveRecord::Base

# Assoziations
  belongs_to :member

# Validations
  validates_presence_of :amount, :starting_date

# Callbacks
  # TODO: http://ruby-journal.com/how-to-track-changes-with-after-callbacks-in-rails-3-or-newer/
  #after_create :calculate_budget

# Methods
  def calculate_budget
    member.budgets.all.each {|b| b.calculate_budget}
  end

end
