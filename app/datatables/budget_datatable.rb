class BudgetDatatable < AjaxDatatablesRails::Base
  # http://bobfly.blogspot.de/2015/05/rails-4-datatables-foundation.html
  AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Budget.title Budget.promise Budget.start_date Budget.end_date Member.last_name Donation.name)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Budget.title Budget.promise Budget.start_date Budget.end_date Member.last_name Member.first_name Donation.name)
  end

  private

  def data
    records.map do |record|
      [
          record.title,
          number_to_currency(record.promise, locale: :de),
          I18n.l(record.start_date, format: :long),
          I18n.l(record.end_date, format: :long),
          link_to(record.member.full_name, v.member_path(record.member_id)),
          link_to(record.donation.name, v.donation_path(record.donation_id)),
          link_to(v.budget_path(record.id), class: "" ) do
            content_tag(:span, "", class: "glyphicon glyphicon-search", title: I18n.t('table.show'))
          end,
          link_to(v.edit_budget_path(record.id), class: "" ) do
            content_tag(:span, "", class: "glyphicon glyphicon-edit", title: I18n.t('table.edit'))
          end,
          link_to(v.budget_path(record.id), method: :delete, data: {confirm: 'Are you sure?'}) do
            content_tag(:span, "", class: "glyphicon glyphicon-trash color-red", title: I18n.t('table.delete') )
          end,
          'DT_RowClass': "danger",
          "DT_RowId": record.id
      ]
    end
  end

  def get_raw_records
    # insert query here
    Budget.includes(:member, :donation).joins(:member, :donation).all
  end

# ==== Insert 'presenter'-like methods below if necessary

  def_delegator :@view, :link_to
  def_delegator :@view, :html_safe
  def_delegator :@view, :content_tag
  def_delegator :@view, :number_to_currency

  def v
    @view
  end

end
