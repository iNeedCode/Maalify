class BudgetMemberReportPDF < Prawn::Document

  # http://www.rubydoc.info/github/sandal/prawn/Prawn/Table
  # http://adamalbrecht.com/2014/01/14/generate-clean-testable-pdf-reports-in-rails-with-prawn/
  TABLE_ROW_COLORS = ["FFFFFF", "e5e5e5"]
  PAGE_WIDTH = 525
  TABLE_FONT_SIZE = 7
  DEFAULT_FONT_SIZE = 10
  SMALL_FONT_SIZE = 8
  TABLE_BORDER_STYLE = :grid
  TABLE_WIDTHS = [130, 50, 50, 50, 50, 110, 50]
  TABLE_HEADERS = [
      I18n.t('donation.budget'), I18n.t('budget.rest_promise_from_past_budget'),
      I18n.t('budget.promise'), I18n.t('budget.paid'),
      I18n.t('budget.rest_current_budget'), I18n.t('budget.elapsed_time'),
      I18n.t('budget.average_payment')
  ]

  def initialize(members, view_context)
    super(page_size: "A4", page_layout: :portrait)
    @members = members

    @members.each do |member|
      @member = member
      @view = view_context
      font_size DEFAULT_FONT_SIZE
      header
      subheading
      table_budget
      table_receipts
      start_new_page(size: "A4", page_layout: :portrait) unless @members.last == member
    end
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    image "#{Rails.root}/public/maalify-logo.jpg", width: 81, height: 26, at: [8, 8]
    text "#{@member[0][:budget].member.full_name}", size: 12, style: :bold, align: :center

    aims_id = "#{I18n.t('member.aims')}: #{@member[0][:budget].member.aims_id}"
    wassiyyat = "•\t #{I18n.t('member.wassiyyat_number')}: #{@member[0][:budget].member.wassiyyat_number}" if @member[0][:budget].member.wassiyyat
    tanzeem = "•\t #{@member[0][:budget].member.tanzeem}"
    date_of_birth = "•\t #{I18n.t('member.date_of_birth')}: #{I18n.l(@member[0][:budget].member.date_of_birth, format: :default)} (#{@member[0][:budget].member.age})"
    text "#{aims_id} #{wassiyyat} #{tanzeem} #{date_of_birth}", size: SMALL_FONT_SIZE, align: :center
  end

  def subheading
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 10

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], width: PAGE_WIDTH, height: 55) do
      font_size SMALL_FONT_SIZE
      text I18n.t('budget.individual_report'), size: 15, style: :bold, align: :center

      place_of_residence = "#{@member[0][:budget].member.street}, #{@member[0][:budget].member.plz} #{@member[0][:budget].member.city}"
      mobil_no = "•\t #{I18n.t('member.mobile_no')}: #{@member[0][:budget].member.mobile_no}" unless @member[0][:budget].member.mobile_no.empty?
      landline = "•\t #{I18n.t('member.landline')}: #{@member[0][:budget].member.landline}" unless @member[0][:budget].member.landline.empty?
      email = "•\t #{I18n.t('member.email')}: #{@member[0][:budget].member.email}" unless @member[0][:budget].member.email.empty?

      text "#{place_of_residence} #{mobil_no} #{landline} #{email}", align: :center
    end

  end

  def table_budget
    font_size TABLE_FONT_SIZE
    text "#{I18n.t('member.current_budgets')}", size: 12, style: :bold, align: :center

    table budget_rows do
      self.header = true
      self.row_colors = TABLE_ROW_COLORS
      self.column_widths = TABLE_WIDTHS
      self.cell_style = {padding: [3, 5, 3, 3]}
      column(1..4).style(:align => :right)
      column(5).style(:align => :center)
      column(6).style(:align => :right)
      row(0).font_style = :bold
      row(0).style(:align => :center)
    end
  end

  def budget_rows
    [TABLE_HEADERS] +
        @member.map do |budget_member|
          [
              budget_member[:budget].title,
              @view.number_to_currency(budget_member[:budget].rest_promise_from_past_budget, locale: :de, precision: 0),
              @view.number_to_currency(budget_member[:budget].promise, locale: :de, precision: 0),
              @view.number_to_currency(budget_member[:paid_amout], locale: :de, precision: 0),
              @view.number_to_currency(budget_member[:rest_amount], locale: :de, precision: 0),
              "#{@view.l(budget_member[:budget].start_date, format: :default)} - #{@view.l(budget_member[:budget].end_date, format: :default)}",
              @view.number_to_currency(budget_member[:average_amount], locale: :de, precision: 0)
          ]
        end
  end

  def table_receipts
    move_down 15
    font_size TABLE_FONT_SIZE
    text "#{I18n.t('receipt.current')}", size: 12, style: :bold, align: :center

    table receipt_rows do
      self.header = true
      self.row_colors = TABLE_ROW_COLORS
      self.column_widths = [70, 80, 70, 270]
      self.cell_style = {padding: [3, 5, 3, 3]}
      column(2).style(:align => :right)
      row(0).font_style = :bold
      row(0).style(:align => :center)
    end
  end

  def receipt_rows
    @all_receipts = []
    @member.select { |aa| !aa[:receipts].empty? }.each { |so| (@all_receipts << so[:receipts]) }
    @all_receipts.flatten!.uniq!

    [[
         I18n.t('receipt.id'),
         I18n.t('receipt.date'),
         I18n.t('receipt.total'),
         I18n.t('receipt.items'),

     ]] +
        @all_receipts.map do |receipt|
          [
              receipt.id,
              @view.l(receipt.date, format: :long),
              @view.number_to_currency(receipt.total, locale: :de, precision: 0),
              receipt.list_items_with_donation.map { |dd| "#{dd.first}: #{@view.number_to_currency(dd.second, locale: :de, precision: 0)}" }.to_a.join(', ')
          ]
        end
  end
end
