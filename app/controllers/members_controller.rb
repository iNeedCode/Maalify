class MembersController < ApplicationController
  before_action :set_member, only: [:edit, :update, :destroy, :send_mail]

  respond_to :html, :json

  def get_all_members
    @members = Member.all
    respond_with(@members)
  end


  def index
    respond_to do |format|
      format.html
      format.json { render json: MemberDatatable.new(view_context) }
    end
  end

  def budgets
    @member = Member.includes(budgets:[:donation]).find(params[:id])
  end

  def show
    @member = Member.includes(budgets:[:donation]).find(params[:id])
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
    redirect_to member_path(@member), notice: t('mail.success', fullname: @member.full_name)
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:gender, :last_name, :first_name, :aims_id, :wassiyyat, :date_of_birth, :street, :city, :email, :landline, :plz, :mobile_no, :occupation)
    end
end
