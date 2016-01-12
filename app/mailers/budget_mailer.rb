class BudgetMailer < ApplicationMailer

  def mail_to_member(member)
    @member = member
    mail to: member.email,
         subject: "Chanda Übersicht #{l(Date.today, format: '%B')} (#{member.first_name})"
  end

end
