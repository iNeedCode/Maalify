class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @incomes = member.incomes.order(starting_date: :desc)
    respond_with(@incomes)
  end

  def show
    @income = member.incomes.find(params[:id])
    respond_with(@income)
  end

  def new
    @income = member.incomes.new
    respond_with(@income.member, @income)
  end

  def edit
  end

  def create
    @income = member.incomes.new(income_params)
    flash[:notice] = 'Income was successfully created.' if @income.save
    @income.recalculate_budget if (params[:recalculate] == "true")
    respond_with(@income.member, @income)
  end

  def update
    flash[:notice] = 'Income was successfully updated.' if @income.update(income_params)
    @income.recalculate_budget if (params[:recalculate] == "true")

    respond_with(@income.member, @income)
  end

  def destroy
    @income.destroy
    @income.recalculate_budget
    respond_with(@income.member, @income)
  end

protected
  def member
    @member = Member.find(params[:member_id])    
  end


private
    def set_income
      @income = member.incomes.find(params[:id])
    end

    def income_params
      params.require(:income).permit(:amount, :starting_date, :member_id, :recalculate)
    end
end
