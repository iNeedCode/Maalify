class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :send_mail]

  respond_to :html, :json

  def index
    @members = Member.all.order(:last_name, :first_name)
    respond_with(@members)
  end

  def show
    # BudgetMailer.mail_to_member(@member).deliver_later
    respond_with(@member)
  end

  def new
    @member = Member.new
    respond_with(@member)
  end

  def edit
  end

  def create
    @member = Member.new(member_params)
    flash[:notice] = 'Member was successfully created.' if @member.save
    respond_with(@member)
  end

  def update
    flash[:notice] = 'Member was successfully updated.' if @member.update(member_params)
    respond_with(@member)
  end

  def destroy
    @member.destroy
    respond_with(@member)
  end

  def import
    imported = Member.import(params[:file])
    redirect_to members_path, notice: t(:imported, :quantity=> imported)
  end

  def import_page
  end

  def send_mail
    BudgetMailer.mail_to_member(@member).deliver_later
    redirect_to member_path(@member), notice: t('mail.success')
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:gender, :last_name, :first_name, :aims_id, :wassiyyat, :date_of_birth, :street, :city, :email, :landline, :plz, :mobile_no, :occupation)
    end
end
