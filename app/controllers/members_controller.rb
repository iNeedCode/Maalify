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

  def chart_wassiyyat_data
    @wassiyyat = []
    tanzeems_for_wassiyyat = %W( Khuddam Ansar Lajna)

    eligible_for_wassiyyat = Member.all.select { |member| tanzeems_for_wassiyyat.include?(member.tanzeem) }
    khuddam = eligible_for_wassiyyat.select { |member| member.tanzeem == 'Khuddam' }.group_by(&:wassiyyat)
    ansar = eligible_for_wassiyyat.select { |member| member.tanzeem == 'Ansar' }.group_by(&:wassiyyat)
    lajna = eligible_for_wassiyyat.select { |member| member.tanzeem == 'Lajna' }.group_by(&:wassiyyat)

    @wassiyyat << {name: 'Khuddam', data: [['Ja', khuddam[true].size], ['Nein', khuddam[false].size]]}
    @wassiyyat << {name: 'Ansar', data: [['Ja', ansar[true].size], ['Nein', ansar[false].size]]}
    @wassiyyat << {name: 'Lajna', data: [['Ja', lajna[true].size], ['Nein', lajna[false].size]]}

    render json: @wassiyyat
  end

  def chart_monthly_proceeding
    @monthly_proceeding = []
    khuddam_donations = Donation.where(organization: "Khuddam").map(&:id)
    atfal_donations = Donation.where(organization: "Atfal").map(&:id)
    ansar_donations = Donation.where(organization: "Ansar").map(&:id)
    lajna_donations = Donation.where(organization: "Lajna").map(&:id)
    nasirat_donations = Donation.where(organization: "Nasirat").map(&:id)
    all_donations = Donation.where(organization: "All").map(&:id)


    @monthly_proceeding << {name: 'Khuddam', data: ReceiptItem.includes(:receipt).joins(:receipt).where(donation: khuddam_donations).order('receipts.date DESC').map{|ri| [ri.amount, ri.receipt.date]}.each_with_object(Hash.new(0)) { |word, counts| counts[word[1].strftime('%Y-%m')] += word[0] }.to_a }

    @monthly_proceeding << {name: 'Atfal', data: ReceiptItem.includes(:receipt).joins(:receipt).where(donation: atfal_donations).order('receipts.date DESC').map{|ri| [ri.amount, ri.receipt.date]}.each_with_object(Hash.new(0)) { |word, counts| counts[word[1].strftime('%Y-%m')] += word[0] }.to_a }
    @monthly_proceeding << {name: 'Ansar', data: ReceiptItem.includes(:receipt).joins(:receipt).where(donation: ansar_donations).order('receipts.date DESC').map{|ri| [ri.amount, ri.receipt.date]}.each_with_object(Hash.new(0)) { |word, counts| counts[word[1].strftime('%Y-%m')] += word[0] }.to_a }
    @monthly_proceeding << {name: 'Lajna', data: ReceiptItem.includes(:receipt).joins(:receipt).where(donation: lajna_donations).order('receipts.date DESC').map{|ri| [ri.amount, ri.receipt.date]}.each_with_object(Hash.new(0)) { |word, counts| counts[word[1].strftime('%Y-%m')] += word[0] }.to_a }
    @monthly_proceeding << {name: 'Nasirat', data: ReceiptItem.includes(:receipt).joins(:receipt).where(donation: nasirat_donations).order('receipts.date DESC').map{|ri| [ri.amount, ri.receipt.date]}.each_with_object(Hash.new(0)) { |word, counts| counts[word[1].strftime('%Y-%m')] += word[0] }.to_a }
    @monthly_proceeding << {name: 'All', data: ReceiptItem.includes(:receipt).joins(:receipt).where(donation: all_donations).order('receipts.date DESC').map{|ri| [ri.amount, ri.receipt.date]}.each_with_object(Hash.new(0)) { |word, counts| counts[word[1].strftime('%Y-%m')] += word[0] }.to_a }

    render json: @monthly_proceeding
  end

  def info
    @tanzeem = Member.all.order(:gender).map(&:tanzeem).each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    @occupation = Member.order(:occupation).where.not(occupation: '').group(:occupation).count

    tanzeems_for_wassiyyat = %W( Khuddam Ansar Lajna)
    @eligible_musi_count = Member.all.select { |member| tanzeems_for_wassiyyat.include?(member.tanzeem) }.size
  end

  def budgets
    @member = Member.includes(budgets: [:donation]).find(params[:id])
  end

  def show
    @member = Member.includes(budgets: [:donation]).find(params[:id])
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
    redirect_to members_path, notice: t(:imported, :quantity => imported)
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
    params.require(:member).permit(:gender, :last_name, :first_name, :aims_id, :wassiyyat, :wassiyyat_number, :date_of_birth, :street, :city, :email, :landline, :plz, :mobile_no, :occupation)
  end
end
