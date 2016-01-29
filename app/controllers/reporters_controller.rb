class ReportersController < ApplicationController
  before_action :set_reporter, only: [:show, :edit, :update, :destroy, :send_mail]

  respond_to :html

  def index
    @reporters = Reporter.all.order("updated_at DESC")
    respond_with(@reporters)
  end

  def show
    respond_with(@reporter)
  end

  def send_mail
    ReportMailer.mail_to_subscribers(@reporter).deliver_later
    redirect_to reporters_path, notice: t('reporter.mail.success', emails: @reporter.emails.join(", "))
  end

  def new
    @reporter = Reporter.new
    respond_with(@reporter)
  end

  def edit
  end

  def create
    @reporter = Reporter.new(reporter_params)
    @reporter.save
    respond_with(@reporter)
  end

  def update
    @reporter.update(reporter_params)
    respond_with(@reporter)
  end

  def destroy
    @reporter.destroy
    respond_with(@reporter)
  end

  private
    def set_reporter
      @reporter = Reporter.find(params[:id])
    end

    def reporter_params
      params.require(:reporter).permit(:name, :interval, {donations: []}, {emails: []}, {tanzeems: []})
    end
end
