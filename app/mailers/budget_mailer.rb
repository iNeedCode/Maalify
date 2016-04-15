class BudgetMailer < ApplicationMailer

  def mail_to_member(member)
    @member = member
    reply_address = (@member.gender == 'male') ? Setting.reply_to_male : Setting.reply_to_female

    mail to: member.email,
         reply_to: reply_address,
         subject: "Chanda Übersicht #{l(Date.today, format: '%B')} (#{member.first_name})"
  end

end
