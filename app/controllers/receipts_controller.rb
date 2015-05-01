class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @receipts = member.receipts.order(date: :desc)
    respond_with(@receipts)
  end

  def show
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
    flash[:notice] = 'Receipt was successfully created.' if @receipt.save
    respond_with(@receipt.member, @receipt)
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
