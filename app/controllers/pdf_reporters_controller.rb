class PdfReportersController < ApplicationController
  before_action :set_pdf_reporter, only: [:show, :edit, :update, :destroy]

  respond_to :html, :pdf

  def index
    @pdf_reporters = PdfReporter.all
    respond_with(@pdf_reporters)
  end

  def show
    @members = Member.includes(budgets:[:donation]).where(aims_id: @pdf_reporter.members).map(&:list_currrent_budgets)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = BudgetMemberReportPDF.new( @members, view_context )
        send_data pdf.render, filename: "#{@pdf_reporter.name}.pdf", type: "application/pdf"
      end
    end

    # respond_with(@pdf_reporter)
  end

  def new
    @pdf_reporter = PdfReporter.new
    respond_with(@pdf_reporter)
  end

  def edit
  end

  def create
    @pdf_reporter = PdfReporter.new(pdf_reporter_params)
    flash[:notice] = 'PdfReporter was successfully created.' if @pdf_reporter.save
    respond_with(@pdf_reporter)
  end

  def update
    flash[:notice] = 'PdfReporter was successfully updated.' if @pdf_reporter.update(pdf_reporter_params)
    respond_with(@pdf_reporter)
  end

  def destroy
    @pdf_reporter.destroy
    respond_with(@pdf_reporter)
  end

  private
    def set_pdf_reporter
      @pdf_reporter = PdfReporter.find(params[:id])
    end

    def pdf_reporter_params
      params.require(:pdf_reporter).permit(:name, members:[])
    end
end
