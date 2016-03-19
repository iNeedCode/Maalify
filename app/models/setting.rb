class Setting < RailsSettings::CachedSettings
  defaults[:jamaat] = "Jamaat"
  defaults[:mail_contact_tag_for_male] = "Bitte hier Kontaktdaten für den jeweiligen Nazimeen aufnehmen, die Zuständig sind z.B. Sec. Maal. Das wird in der Email angezeigt."
  defaults[:mail_contact_tag_for_female] = "Bitte hier Kontaktdaten für den jeweiligen Nazima aufnehmen, die Zuständig sind z.B. Nazima Maal. Das wird in der Email für Frauen angezeigt angezeigt."
  defaults[:monthly_mail] = 1
end
