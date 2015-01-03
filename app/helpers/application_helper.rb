module ApplicationHelper

	def link_to_telephone(phone)
		phone.present? ? link_to("#{phone}", "tel:#{phone}") : phone
	end

	def link_to_address(address)
		address.present? ? link_to("#{address}", "mailto:#{address}") : address
	end

	def show_boolean_value_as_glyphicon(value)
		if value
			content_tag(:span, "", class: "glyphicon glyphicon-ok")
		else
			content_tag(:span, "", class: "glyphicon glyphicon-remove")
		end
		
	end

end
