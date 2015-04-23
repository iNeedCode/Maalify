class DonationTypesController < ApplicationController
  before_action :set_donation_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @donation_types = DonationType.all
    respond_with(@donation_types)
  end

  def show
    respond_with(@donation_type)
  end

  def new
    @donation_type = DonationType.new
    respond_with(@donation_type)
  end

  def edit
  end

  def create
    @donation_type = DonationType.new(donation_type_params)
    @donation_type.save
    respond_with(@donation_type)
  end

  def update
    @donation_type.update(donation_type_params)
    respond_with(@donation_type)
  end

  def destroy
    @donation_type.destroy
    respond_with(@donation_type)
  end

  private
    def set_donation_type
      @donation_type = DonationType.find(params[:id])
    end

    def donation_type_params
      params.require(:donation_type).permit(:start_date, :name, :end_date, :donation_type)
    end
end
