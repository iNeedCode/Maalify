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
d1 = Donation.create name: 'Hissa Amad', organization: 'All', budget: true, formula: '0.1*12', minimum_budget: 0, description: 'Für die allgemeinen Kosten der der MKAD'
d1 = Donation.create name: 'Chanda Aam', organization: 'All', budget: true, formula: '0.0625*12', minimum_budget: 0, description: 'Für die allgemeinen Kosten der der MKAD'
d3 = Donation.create name: 'MTA', organization: 'All', budget: false, formula: '', minimum_budget: 0, description: 'Für die Erhaltung und Ausgaben von Muslim TV Ahmadiyya'
d3 = Donation.create name: '100 Moschee', organization: 'All', budget: false, formula: '', minimum_budget: 0, description: 'Für das 100 Moschee Projekt'

d1 = Donation.create name: 'Majlis Khuddam', organization: 'Khuddam', budget: true, formula: '0.01*12', minimum_budget: 36, description: 'Für die allgemeinen Kosten der der MKAD'
d2 = Donation.create name: 'ijtema Khuddam', organization: 'Khuddam', budget: true, formula: '0.025', minimum_budget: 24, description: 'Für das jährliche Ijtema'
d3 = Donation.create name: 'Ishaat Khuddam', organization: 'Khuddam', budget: false, formula: '', minimum_budget: 3, description: 'Für das betreiben der Zeitschriften der MKAD'

ap 'created dataseed'
