class Receipt < ActiveRecord::Base

# Assoziations
  belongs_to :member

  def total
  	# calc sum of receipt_items
  	100
  end
end
