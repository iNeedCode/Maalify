def delete_all_models()
  models = %w{ Member Income Receipt }
  Member.delete_all
  Income.delete_all
  Receipt.delete_all
  ReceiptItem.delete_all
  Donation.delete_all
  Budget.delete_all
end

delete_all_models()

# ========= CREATE DONATION TYPES
d1 = Donation.create name: 'Majlis', organization: 'Khuddam', budget: true, formula: '0.01*12', minimum_budget: 36
d2 = Donation.create name: 'ijtema', organization: 'Khuddam', budget: true, formula: '0.025', minimum_budget: 24
d3 = Donation.create name: 'Ishaat', organization: 'Khuddam', budget: false, formula: '', minimum_budget: 3

# ========= CREATE MEMBERS
m1 = Member.create(last_name: 'Malik', first_name: 'Akhlaq', wassiyyat: true,
                   date_of_birth: '1987-08-18', street: 'Fünkirchner Straße 25', city: 'Darmstadt',
                   plz: 64295, mobile_no: '01742055415', landline: '061516607247',
                   occupation: 'Angestellter', email: 'akhlaq87@gmail.com', aims_id: 14649)

m2 = Member.create(last_name: 'Malik', first_name: 'Ishtiaq', wassiyyat: true,
                   date_of_birth: '1978-02-18', street: 'Fünkirchner Straße 25', city: 'Darmstadt',
                   plz: 64295, mobile_no: '01706582200', landline: '061516607247',
                   occupation: 'Selbsständig', email: 'info@automalik.de', aims_id: 14642)

# ========= CREATE MEMBERS INCOME
Income.create(starting_date: '2015-01-01', member_id: '14649', amount: 1000)
Income.create(starting_date: '2015-01-01', member_id: '14642', amount: 2500)


# ========= CREATE MEMBERS RECEIPT
r1 = Receipt.create(receipt_id: 12344, :date => '2014-01-01', member: m1)
r2 = Receipt.create(receipt_id: 12345, :date => '2014-02-01', member: m1)
r3 = Receipt.create(receipt_id: 12346, :date => '2014-03-01', member: m2)

# ========= CREATE MEMBERS RECEIPT ITEMS
r1.items.create(amount: 125, donation: d2)
r1.items.create(amount: 33, donation: d2)
r2.items.create(amount: 42, donation: d1)
r3.items.create(amount: 46, donation: d3)

# ========= CREATE BUDGET FOR MEMBER
Budget.create title: 'MKAD 2014-15', start_date: '2014-11-01', end_date: '2015-10-31', member: m2, donation: d1
Budget.create title: 'MKAD 2014-15', start_date: '2014-11-01', end_date: '2015-10-31', member: m2, donation: d2
Budget.create title: 'MKAD 2014-15', start_date: '2014-11-01', end_date: '2015-10-31', member: m2, donation: d3
Budget.create title: 'MKAD 2014-15', start_date: '2014-11-01', end_date: '2015-10-31', member: m1, donation: d1
Budget.create title: 'MKAD 2014-15', start_date: '2014-11-01', end_date: '2015-10-31', member: m1, donation: d2
Budget.create title: 'MKAD 2014-15', start_date: '2014-11-01', end_date: '2015-10-31', member: m1, donation: d3


ap 'created dataseed'
