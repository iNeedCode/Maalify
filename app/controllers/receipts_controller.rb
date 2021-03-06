class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:edit, :update, :destroy]

  respond_to :html, :json

  def all
    respond_to do |format|
      format.html
      format.json { render json: ReceiptDatatable.new(view_context) }
    end
  end

  def index
    @member = Member.includes(receipts: [items: [:donation]]).find(params[:member_id])
    @receipts = @member.receipts.order(date: :desc)
    respond_with(@receipts)
  end

  def show
    @member = Member.includes(receipts: [items: [:donation]]).find(params[:member_id])
    @receipt = member.receipts.find(params[:id])
    respond_with(@receipt)
  end

  def new
    @receipt = member.receipts.new
    respond_with(@receipt.member, @receipt)
  end

  def edit
  end

  def create
    @receipt = member.receipts.new(receipt_params)
    if @receipt.save
      flash[:notice] = t('view.receipt.created', {fullname: @receipt.member.full_name, amount: @receipt.total})
      redirect_to root_path
    else
      respond_with(@receipt.member, @receipt)
    end
  end

  def update
    flash[:notice] = 'Receipt was successfully updated.' if @receipt.update(receipt_params)
    respond_with(@receipt.member, @receipt)
  end

  def destroy
    @receipt.destroy
    respond_with(@receipt.member, @receipt)
  end

  protected
  def member
    @member = Member.find(params[:member_id])
  end


  private
  def set_receipt
    @receipt = member.receipts.find(params[:id])
  end

  def receipt_params
    params.require(:receipt).permit(:receipt_id, :date, :member_id, items_attributes: [:id, :amount, :donation_id, :_destroy])
  end
end
