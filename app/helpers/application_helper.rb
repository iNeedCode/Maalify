module ApplicationHelper

  def link_to_telephone(phone)
    phone.present? ? link_to("#{phone}", "tel:#{phone}") : phone
  end

  def link_to_address(address)
    address.present? ? link_to("#{address}", "mailto:#{address}") : address
  end

  def show_boolean_value_as_glyphicon(value, title = 'Wassiyat')
    if value
      content_tag(:span, "", class: "glyphicon glyphicon-ok", title: title, data: {toggle: "toogle", placement: "placement"})
    else
      content_tag(:span, "", class: "glyphicon glyphicon-remove", title: title, data: {toggle: "toogle", placement: "placement"})
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |buidler|
      render(association.to_s.singularize + '_fields', f: buidler)
    end
    link_to(content_tag(:span, "", class: "glyphicon glyphicon-plus")+" #{name}", '#',
            class: 'add_fields btn btn-default btn-sm', data: {id: id, fields: fields.gsub("\n", "")})
  end

end
