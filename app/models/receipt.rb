class Receipt < ActiveRecord::Base

# Assoziations
  belongs_to :member
  has_many :items, class_name: 'ReceiptItem', dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

# Validations
  validates_associated :items, presence: true
  validates :receipt_id, uniqueness: true, presence: true
  validate :budget_exists_for_date?
  validate :single_donation_used_in_one_receipt


# Methods
  def total
    sum = 0
    items.collect { |li| li.amount.present? ? sum += li.amount : 0 }
    sum
  end

  def date_of_last_change
    Receipt.includes(:items).where(receipt_id: self.id).order("receipt_items.updated_at DESC").collect(&:items).flatten.map(&:updated_at).first
  end

  def list_items_with_donation
    Donation.includes(:receipt_items).where(receipt_items:{receipt_id: self.id}).pluck(:name, :amount)
  end

  private
  def single_donation_used_in_one_receipt
    unless items.map(&:donation_id).length == items.map(&:donation_id).uniq.length
      errors.add(:items, "#{I18n.t('receipt.error.double_receipt_item')}")
    end
  end

  def budget_exists_for_date?
    all_member_budgets = Budget.where(member: member)
    matches = nil
    items.each do |item|
      matches = all_member_budgets.select do |budget|
        (budget.donation_id == item.donation_id) && (budget.start_date..budget.end_date).include?(date)
      end
    end

    if matches.nil? || matches.empty?
      errors.add(:items, "#{I18n.t('receipt.error.no_budget_period_available')}")
    end
  end

end
