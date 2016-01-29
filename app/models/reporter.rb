class Reporter < ActiveRecord::Base

  EMAIL_VALIDATION_REGEXP = Regexp.new('\A(?!(?:(?:\x22?\x5C[\x00-\x7E]\x22?)|(?:\x22?[^\x5C\x22]\x22?)){255,})(?!(?:(?:\x22?\x5C[\x00-\x7E]\x22?)|(?:\x22?[^\x5C\x22]\x22?)){65,}@)(?:(?:[\x21\x23-\x27\x2A\x2B\x2D\x2F-\x39\x3D\x3F\x5E-\x7E]+)|(?:\x22(?:[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7F]|(?:\x5C[\x00-\x7F]))*\x22))(?:\.(?:(?:[\x21\x23-\x27\x2A\x2B\x2D\x2F-\x39\x3D\x3F\x5E-\x7E]+)|(?:\x22(?:[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7F]|(?:\x5C[\x00-\x7F]))*\x22)))*@(?:(?:(?!.*[^.]{64,})(?:(?:(?:xn--)?[a-z0-9]+(?:-[a-z0-9]+)*\.){1,126}){1,}(?:(?:[a-z][a-z0-9]*)|(?:(?:xn--)[a-z0-9]+))(?:-[a-z0-9]+)*)|(?:\[(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){7})|(?:(?!(?:.*[a-f0-9][:\]]){7,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?)))|(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){5}:)|(?:(?!(?:.*[a-f0-9]:){5,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3}:)?)))?(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))(?:\.(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))){3}))\]))\z', true)

  validates_each :emails do |record, attr, value|
    value.each do |email|
      record.errors.add attr, I18n.t('reporter.error.not_valid_email', email: email) if (email =~ EMAIL_VALIDATION_REGEXP) == nil
    end
  end

  def self.list_available_intervals()
    [
        %W(#{I18n.t('reporter.interval.monthly')} 28),
        %W(#{I18n.t('reporter.interval.biweekly')} 14,28),
        %W(#{I18n.t('reporter.interval.weekly')} 7,14,21,28)
    ]
  end

  def overview
    @rueckgabe

    if self.tanzeems.include? "All"
      @rueckgabe = Budget.joins(:donation)
                      .select("budgets.title, SUM(budgets.promise) AS promise, SUM(budgets.rest_promise_from_past_budget) AS rest_promise_from_past_budget")
                      .where('donation_id IN (?) and ? >= start_date and ? <= end_date', self.donations, Date.today, Date.today)
                      .group(:title)


      @rueckgabe.each do |budget|
        sum_of_paid_budget = Budget.find_by(title: budget.title).getAllReceiptsItemsfromBudgetPeriod.map(&:amount).sum
        budget.class_eval {attr_accessor :paid_amount_whole_budget}
        budget.paid_amount_whole_budget = sum_of_paid_budget
        budget.class_eval {attr_accessor :paid_percent}
        budget.paid_percent = ((sum_of_paid_budget / budget.promise.to_f) * 100).round(2)
        budget.class_eval {attr_accessor :rest_amount}
        budget.rest_amount = budget.promise + budget.rest_promise_from_past_budget - sum_of_paid_budget
      end

    else
      members = Member.all.select {|member| self.tanzeems.include?(member.tanzeem)}.map(&:id).map(&:to_s)
      @rueckgabe = Budget.joins(:donation)
                       .select("budgets.title, SUM(budgets.promise) AS promise, SUM(budgets.rest_promise_from_past_budget) AS rest_promise_from_past_budget")
                       .where('donation_id IN (?) and member_id IN (?) and ? >= start_date and ? <= end_date', self.donations, members, Date.today, Date.today)
                       .group(:title)

      @rueckgabe.each do |budget|
        sum_of_paid_budget = Budget.find_by(title: budget.title).getAllReceiptsItemsfromBudgetPeriod(members).map(&:amount).sum
        budget.class_eval {attr_accessor :paid_amount_whole_budget}
        budget.paid_amount_whole_budget = sum_of_paid_budget
        budget.class_eval {attr_accessor :paid_percent}
        budget.paid_percent = ((sum_of_paid_budget / budget.promise.to_f) * 100).round(2)
        budget.class_eval {attr_accessor :rest_amount}
        budget.rest_amount = budget.promise + budget.rest_promise_from_past_budget - sum_of_paid_budget
      end

    end

    @rueckgabe
  end

end
