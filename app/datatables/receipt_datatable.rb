class ReceiptDatatable < AjaxDatatablesRails::Base
  # http://bobfly.blogspot.de/2015/05/rails-4-datatables-foundation.html
  AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w( Member.last_name Receipt.receipt_id Receipt.date )
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w( Receipt.receipt_id Receipt.date Member.last_name Member.first_name Member.aims_id )
  end

  private

  def data
    records.map do |record|
      [
          link_to(record.member.full_name, v.member_path(record.member_id)),
          link_to(record.receipt_id, v.member_receipt_path(record.member_id, record.receipt_id)),
          I18n.l(record.date, format: :long),
          number_to_currency(record.total, locale: :de),
          record.list_items_with_donation,
          I18n.l(record.date_of_last_change, format: :short),
          link_to(v.member_receipt_path(record.member_id, record.receipt_id), class: "") do
            content_tag(:span, "", class: "glyphicon glyphicon-search", title: I18n.t('table.show') )
          end,
          link_to(v.edit_member_receipt_path(record.member_id, record.receipt_id), class: "") do
            content_tag(:span, "", class: "glyphicon glyphicon-edit", title: I18n.t('table.edit') )
          end,
          link_to(v.member_receipt_path(record.member_id, record.receipt_id), method: :delete, data: {confirm: 'Are you sure?'}) do
            content_tag(:span, "", class: "glyphicon glyphicon-trash color-red", title: I18n.t('table.delete') )
          end,
          "DT_RowId": record.receipt_id
      ]
    end
  end

  def get_raw_records
    # insert query here
    Receipt.includes(:member, items: [:donation]).joins(:member).all.order(date: :desc)
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
