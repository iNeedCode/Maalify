namespace :cron do
  desc "Send account emails"
  task deliver_emails: :environment do
    members = Member.where(aims_id: 14649)
    members.each do |member|
      BudgetMailer.mail_to_member(member).deliver_later
    end
  end
end
