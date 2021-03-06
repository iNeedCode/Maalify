class MemberDatatable < AjaxDatatablesRails::Base
  # http://bobfly.blogspot.de/2015/05/rails-4-datatables-foundation.html
  AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Member.aims_id Member.last_name Member.first_name Member.street Member.city Member.email Member.plz Member.mobile_no Member.occupation )
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Member.aims_id Member.last_name Member.first_name Member.street Member.city Member.email Member.plz Member.mobile_no Member.landline Member.occupation )
  end

  private

  def data
    records.map do |record|
      [
          record.aims_id,
          record.last_name,
          link_to(record.first_name, v.member_path(record.aims_id)),
          record.tanzeem,
          show_boolean_value_as_glyphicon(record.wassiyyat),
          content_tag(:span, "#{record.age}" , title: record.date_of_birth.strftime("%d.%m.%Y"), data: {toggle: "toogle", placement: "placement"}),
          record.street,
          record.plz,
          record.city,
          link_to_telephone(record.landline),
          link_to_telephone(record.mobile_no),
          link_to_address(record.email),
          link_to(v.member_path(record.aims_id), class: "") do
            content_tag(:span, "", class: "glyphicon glyphicon-search", title: I18n.t('table.show') )
          end,
          link_to(v.edit_member_path(record.aims_id), class: "") do
            content_tag(:span, "", class: "glyphicon glyphicon-edit", title: I18n.t('table.edit') )
          end,
          link_to(v.member_path(record.aims_id), method: :delete, data: {confirm: 'Are you sure?'}) do
            content_tag(:span, "", class: "glyphicon glyphicon-trash color-red", title: I18n.t('table.delete') )
          end,
          'DT_RowClass': "danger",
          "DT_RowId": record.id
      ]
    end
  end

  def get_raw_records
    # insert query here
    Member.all
  end

# ==== Insert 'presenter'-like methods below if necessary

  def_delegator :@view, :link_to
  def_delegator :@view, :html_safe
  def_delegator :@view, :content_tag
  def_delegator :@view, :link_to_telephone
  def_delegator :@view, :link_to_address
  def_delegator :@view, :show_boolean_value_as_glyphicon

  def v
    @view
  end

end
