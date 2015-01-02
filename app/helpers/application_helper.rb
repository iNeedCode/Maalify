module ApplicationHelper

	def link_to_telephone(phone)
		phone.present? ? link_to("#{phone}", "tel:#{phone}") : phone
	end

	def link_to_address(address)
		address.present? ? link_to("#{address}", "mailto:#{address}") : address
		
	end
end
