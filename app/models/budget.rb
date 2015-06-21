class Budget < ActiveRecord::Base
  belongs_to :member
  belongs_to :donation

  def test_method
    self.promise = 10
  end

end
