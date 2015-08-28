class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @budgets = Budget.all
    respond_with(@budgets)
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
    members_selected = budget_params[:member_id].reject { |m| m.empty? }
    parameters = budget_params
    members_selected.each { |member_id| puts member_id }
   # debugger
    @budget = Budget.new(budget_params)
    @budget.save
    respond_with(@budget)
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
    params.require(:budget).permit(:title, :promise, :start_date, :end_date, :donation_id, member_id: [])
  end
end
