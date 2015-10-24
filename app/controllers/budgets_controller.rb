class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @budgets = Budget.all
    respond_with(@budgets)
  end

  def new_with_parameter
    @budget = Budget.where(title: params[:budget_title]).first
    @budget.member_id = params[:member_id]
    ap @budget
    ap params
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
    respond_with(@budget)
  end

  def new
    @budget = Budget.new
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
      flash[:notice] = "Successfully created #{@budgets.size} budgets."
      redirect_to budgets_path
    end
  end

  def update
    flash[:notice] = 'Member was successfully updated.' if @budget.update(budget_params)
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
