class RemoveStartDateAndEndDateFromDonation < ActiveRecord::Migration
  def change
    remove_column :donations, :start_date, :date
    remove_column :donations, :end_date, :date
  end
end
