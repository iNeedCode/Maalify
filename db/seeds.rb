# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email


m = Member.new(:last_name => "Malik", :first_name => "Akhlaq", :wassiyyat => true, 
	:date_of_birth => "1987-08-18", :street => "Fünkirchner Straße 25",  :city => "Darmstadt",
	:plz => 64295, :mobile_no => 01742055415, :landline => 061516607247,
	:occupation => "Angestellter", :email => "akhlaq87@gmail.com", :aims_id => 14649)
m.save