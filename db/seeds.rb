# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

def delete_all_models()
	# models = %w{ Member Income Receipt }	
	Member.delete_all
	Income.delete_all
	Receipt.delete_all
	ReceiptItem.delete_all
end

delete_all_models()

m1 = Member.create(:last_name => "Malik", :first_name => "Akhlaq", :wassiyyat => true, 
	:date_of_birth => "1987-08-18", :street => "Fünkirchner Straße 25",  :city => "Darmstadt",
	:plz => 64295, :mobile_no => '01742055415', :landline => '061516607247',
	:occupation => "Angestellter", :email => "akhlaq87@gmail.com", :aims_id => 14649)

m2 = Member.create(:last_name => "Malik", :first_name => "Ishtiaq", :wassiyyat => true, 
	:date_of_birth => "1978-02-18", :street => "Fünkirchner Straße 25",  :city => "Darmstadt",
	:plz => 64295, :mobile_no => '01706582200', :landline => '061516607247',
	:occupation => "Selbsständig", :email => "info@automalik.de", :aims_id => 14642)

Income.create(:starting_date => "2015-01-01", :member_id => "14649", :amount => 2400)
Income.create(:starting_date => "2015-01-01", :member_id => "14642", :amount => 2500)

r1 = Receipt.create(:receipt_id=>12344, :date=>"2014-01-01", :member_id=>"14642")
Receipt.create(:receipt_id=>12345, :date=>"2014-02-01", :member_id=>"14642")
r2 = Receipt.create(:receipt_id=>12346, :date=>"2014-03-01", :member_id=>"14649")

r1.items.create(amount: 120)
r2.items.create(amount: 40)

puts "created dataseed"
