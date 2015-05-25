def delete_all_models()
	models = %w{ Member Income Receipt }
	Member.delete_all
	Income.delete_all
	Receipt.delete_all
	ReceiptItem.delete_all
	Donation.delete_all
end

delete_all_models()

# ========= CREATE DONATION TYPES
d1 = Donation.create name: "Majlis", budget: true, organization: "Khuddam", formula: '0,01*12'
d2 = Donation.create name: "ijtema", budget: true, organization: "Khuddam", formula: '0,025'
d3 = Donation.create name: "Ishaat", budget: false, organization: "Khuddam", formula: '3'

# ========= CREATE MEMBERS
m1 = Member.create(:last_name => "Malik", :first_name => "Akhlaq", :wassiyyat => true,
	:date_of_birth => "1987-08-18", :street => "Fünkirchner Straße 25",  :city => "Darmstadt",
	:plz => 64295, :mobile_no => '01742055415', :landline => '061516607247',
	:occupation => "Angestellter", :email => "akhlaq87@gmail.com", :aims_id => 14649)

m2 = Member.create(:last_name => "Malik", :first_name => "Ishtiaq", :wassiyyat => true,
	:date_of_birth => "1978-02-18", :street => "Fünkirchner Straße 25",  :city => "Darmstadt",
	:plz => 64295, :mobile_no => '01706582200', :landline => '061516607247',
	:occupation => "Selbsständig", :email => "info@automalik.de", :aims_id => 14642)

# ========= CREATE MEMBERS INCOME
Income.create(:starting_date => "2015-01-01", :member_id => "14649", :amount => 2000)
Income.create(:starting_date => "2015-01-01", :member_id => "14642", :amount => 2500)


# ========= CREATE MEMBERS RECEIPT
r1 = Receipt.create(:receipt_id=>12344, :date=>"2014-01-01", member: m1)
r2 = Receipt.create(:receipt_id=>12345, :date=>"2014-02-01", member: m1)
r3 = Receipt.create(:receipt_id=>12346, :date=>"2014-03-01", member: m2)

# ========= CREATE MEMBERS RECEIPT ITEMS
r1.items.create(amount: 125, donation: d2)
r1.items.create(amount: 33, donation: d2)
r2.items.create(amount: 42, donation: d1)
r3.items.create(amount: 46, donation: d3)


ap "created dataseed"
