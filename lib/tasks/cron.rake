namespace :cron do
  desc "Send emails to members that are registred with email"
  task deliver_emails: :environment do
    members = Member.where.not(email:'')
    members.each do |member|

      I18n.with_locale(:de) do
        BudgetMailer.mail_to_member(member).deliver_later
      end

    end
  end
end
