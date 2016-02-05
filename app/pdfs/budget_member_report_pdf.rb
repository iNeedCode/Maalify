class BudgetMemberReportPDF < Prawn::Document

  TABLE_ROW_COLORS = ["FFFFFF", "e5e5e5"]
  PAGE_WIDTH = 780
  TABLE_FONT_SIZE = 7
  DEFAULT_FONT_SIZE = 10
  SMALL_FONT_SIZE = 8
  TABLE_BORDER_STYLE = :grid
  # http://www.rubydoc.info/github/sandal/prawn/Prawn/Table
  TABLE_WIDTHS = [120, 60, 60, 60, 60, 100, 60]
  TABLE_HEADERS = [
      I18n.t('donation.budget'), I18n.t('budget.rest_promise_from_past_budget'),
      I18n.t('budget.promise'), I18n.t('budget.paid'),
      I18n.t('budget.rest_current_budget'), I18n.t('budget.elapsed_time'),
      I18n.t('budget.average_payment')
  ]
  # http://adamalbrecht.com/2014/01/14/generate-clean-testable-pdf-reports-in-rails-with-prawn/

  def initialize(members, view_context)
    super(page_size: "A4", page_layout: :landscape)
    @members = members

    @members.each do |member|
      @member = member
      @view = view_context
      font_size DEFAULT_FONT_SIZE
      header
      text_content
      table_content
      start_new_page(size: "A4", page_layout: :landscape) unless @members.last == member
    end
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    image "#{Rails.root}/public/maalify-logo.jpg", width: 62, height: 25, at: [8, 8]
    text "#{@member[0][:budget].member.full_name}", size: 12, style: :bold, align: :center
    text "#{I18n.t('member.aims')}: #{@member[0][:budget].member.aims_id}", size: SMALL_FONT_SIZE, align: :center
  end

  def text_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 10

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], width: PAGE_WIDTH, height: 55) do
      font_size SMALL_FONT_SIZE
      text_box "#{I18n.t('member.email')}: #{@member[0][:budget].member.email}", at: [10, 50], size: SMALL_FONT_SIZE, align: :right unless @member[0][:budget].member.email.nil?
      text I18n.t('budget.individual_report'), size: 15, style: :bold, align: :center

      wassiyyat = "#{I18n.t('member.wassiyyat_number')}: #{@member[0][:budget].member.wassiyyat_number}" if @member[0][:budget].member.wassiyyat
      place_of_residence = "#{@member[0][:budget].member.street}, #{@member[0][:budget].member.plz} #{@member[0][:budget].member.city}"
      date_of_birth = "#{I18n.t('member.date_of_birth')}: #{I18n.l(@member[0][:budget].member.date_of_birth, format: :default)}(#{@member[0][:budget].member.age})"
      tanzeem = "#{@member[0][:budget].member.tanzeem}"

      text "#{wassiyyat} \t| #{date_of_birth} \t| #{place_of_residence} \t| #{tanzeem}"
    end

    # bounding_box([300, y_position], :width => 270, :height => 100) do
    #   text "Duis vel", size: 15, style: :bold
    #   text "justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam"
    # end

  end

  def table_content
    font_size TABLE_FONT_SIZE

    table member_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = TABLE_ROW_COLORS
      self.column_widths = TABLE_WIDTHS
    end
  end

  def member_rows
    [TABLE_HEADERS] +
        @member.map do |budget_member|
          [budget_member[:budget].title, @view.number_to_currency(budget_member[:budget].rest_promise_from_past_budget, locale: :de, precision: 0),
           @view.number_to_currency(budget_member[:budget].promise, locale: :de, precision: 0), @view.number_to_currency(budget_member[:paid_amout], locale: :de, precision: 0),
           @view.number_to_currency(budget_member[:rest_amount], locale: :de, precision: 0), "#{@view.l(budget_member[:budget].start_date, format: :default)} - #{@view.l(budget_member[:budget].end_date, format: :default)}",
           @view.number_to_currency(budget_member[:average_amount], locale: :de, precision: 0)
          ]
        end
  end
end
