Donation.delete_all

# ========= CREATE DONATION TYPES
Donation.create name: 'Hissa Amad', organization: 'All', budget: true, formula: '0.1*12', minimum_budget: 0, description: 'Für Mitglieder die dem Wassiyyat-System angehörig sind.'
Donation.create name: 'Chanda Aam', organization: 'All', budget: true, formula: '0.0625*12', minimum_budget: 0, description: 'Chanda der Jamaat'
Donation.create name: 'MTA', organization: 'All', budget: false, formula: '', minimum_budget: 60, description: 'Für das betreiben des Senders Muslim Televion Ahmadiyya (MTA).'
Donation.create name: '100 Moschee', organization: 'All', budget: false, formula: '', minimum_budget: 0, description: 'Für das 100 Moscheen Projekt.'

# Khuddam
Donation.create name: 'Khuddam Majlis', organization: 'Khuddam', budget: true, formula: '0.01*12', minimum_budget: 36, description: 'Für die Allgemeinen Kosten der Unterorganisation.'
Donation.create name: 'Khuddam Ijtema', organization: 'Khuddam', budget: true, formula: '0.025', minimum_budget: 24, description: 'Für die alljährliche Versammlung.'
Donation.create name: 'Khuddam Ishaat', organization: 'Khuddam', budget: false, formula: '', minimum_budget: 3, description: 'Für das betreiben der MKAD Zeitschriften.'
Donation.create name: 'Atfal Majlis', organization: 'Atfal', budget: false, formula: '', minimum_budget: 13, description: 'Für die Allgemeinen Kosten der Unterorganisation.'
Donation.create name: 'Atfal Ijtema', organization: 'Atfal', budget: false, formula: '', minimum_budget: 6, description: 'Für die alljährliche Versammlung.'

# Lajna
Donation.create name: 'Lajna Fund', organization: 'Lajna', budget: true, formula: '0.01*12', minimum_budget: 36, description: 'Für die Allgemeinen Kosten der Unterorganisation.'
Donation.create name: 'Lajna Ijtema', organization: 'Lajna', budget: false, formula: '', minimum_budget: 10, description: 'Für die alljährliche Versammlung.'
Donation.create name: 'Lajna Ishaat', organization: 'Lajna', budget: false, formula: '', minimum_budget: 2, description: 'Für das betreiben der Lajna Zeitschriften.'
Donation.create name: 'Nasirat Fund', organization: 'Nasirat', budget: false, formula: '', minimum_budget: 12, description: 'Für die Allgemeinen Kosten der Unterorganisation.'
Donation.create name: 'Nasirat Ijtema', organization: 'Nasirat', budget: false, formula: '', minimum_budget: 5, description: 'Für die alljährliche Versammlung.'

puts 'created dataseed'
