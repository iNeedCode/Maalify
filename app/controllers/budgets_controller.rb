class BudgetsController < ApplicationController
  before_action :set_budget, only: [:edit, :update, :destroy]

  respond_to :html, :json

  def index
    @budget_overview = Budget.remaining_promise_for_whole_budget_title
    respond_with(@budgets)
  end

  def all_budgets
    respond_to do |format|
      format.html
      format.json { render json: BudgetDatatable.new(view_context) }
    end
  end

  def new_with_parameter
    @budget = Budget.includes(:donation).where(title: params[:budget_title]).first
    @budget.member_id = params[:member_id]
    render :new
  end

  def preview
    @budget_previews = []
    @member_ids = budget_params[:member_id].reject { |m| m.empty? }
    redirect_to :back, :flash => {:error => 'Select at least one member.'} if @member_ids.empty?

    @member_ids.each do |member_id|
      b = Budget.new(budget_params)
      b.member_id = member_id
      b.calculate_budget
      b.transfer_old_remaining_promise_to_current_budget
      redirect_to :back, :flash => {:error => "#{b.member.full_name} => #{b.errors.full_messages}"} unless b.valid?
      @budget_previews << b
    end
  end

  def show
    @budget = Budget.includes(:donation, member:[receipts: [:items]]).find(params[:id])
    respond_with(@budget)
  end

  def new
    @budget = Budget.includes(:donation).new
    respond_with(@budget)
  end

  def edit
  end

  def create
    @budget_validate_values = []
    @budgets = []
    budget_parameters = params[:budgets]
    budget_parameters.each do |b|
      budget = Budget.new(b.last.to_unsafe_h)
      @budgets << budget
      @budget_validate_values << budget.valid?
      redirect_to new_budget_path,
                  flash: {error: "Budget/Versprechen oder Restbetrag von #{budget.member.full_name} korrigieren."} unless budget.valid?
    end

    unless @budget_validate_values.include?(false)
      @budgets.each { |b| b.save }
      flash[:notice] = "Successfully created #{@budgets.size} Budgets."
      redirect_to all_budgets_budgets_path
    end
  end

  def update
    if @budget.update(budget_params)
      flash[:notice] = 'Member was successfully updated.'
      if @budget.none_payer
        @budget.promise = 0
        @budget.rest_promise_from_past_budget = 0
        @budget.save
      end
    end
    respond_with(@budget)
  end

  def destroy
    @budget.destroy
    redirect_to all_budgets_budgets_path, flash: {success: "Budget (#{@budget.title}) von #{@budget.member.full_name} gelöscht!"}
  end

  private
  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:title, :promise, :start_date, :end_date, :rest_promise_from_past_budget, :description, :none_payer, :donation_id, member_id: [])
  end
end
