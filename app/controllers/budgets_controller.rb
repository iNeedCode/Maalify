class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @budgets = Budget.all
    respond_with(@budgets)
  end

  def preview
    @budgets_preview = []
    @member_ids = budget_params[:member_id].reject { |m| m.empty? }

    @member_ids.each do |member_id|
      b = Budget.new(budget_params)
      b.member_id = member_id
      b.calculate_budget
      b.transfer_old_remaining_promise_to_current_budget
      @budgets_preview << b
    end

    respond_with(@budget)
  end

  def show
    respond_with(@budget)
  end

  def new
    @budget = Budget.new
    respond_with(@budget)
  end

  def edit
  end

  def create
    # TODO: save actual budget passed
    @budget_validate_values = []
    @budgets = []
    budget_parameters = params[:budgets]
    budget_parameters.each do |b|
      budget = Budget.new(b.last.to_unsafe_h)
      @budgets << budget
      @budget_validate_values << budget.valid?
    end
    if @budget_validate_values.include?(false)
      render action: :new, notice: 'Invitation could not be sent.'
    else
      flash[:notice] = "#{@budgets.inspect}"
      redirect_to budgets_path
    end
    # respond_with(@budget)
  end

  def update
    @budget.update(budget_params)
    respond_with(@budget)
  end

  def destroy
    @budget.destroy
    respond_with(@budget)
  end

  private
  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:title, :promise, :start_date, :end_date, :rest_promise_from_past_budget, :donation_id, member_id: [])
  end
end
