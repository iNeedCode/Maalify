class BudgetMailer < ApplicationMailer

  def mail_to_member(member)
    @member = member
    mail to: member.email,
         subject: "Chanda Übersicht #{Date.today.strftime("%B")}"
  end

end
