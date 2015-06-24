class Income < ActiveRecord::Base

# Assoziations
  belongs_to :member

# Callbacks
  #after_create :calculate_budget

# Methods
  def calculate_budget
    member.budgets.all.each {|b| b.calculate_budget}
  end

end
