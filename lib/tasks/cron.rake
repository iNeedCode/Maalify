namespace :cron do
  desc "Send emails to members that are registred with email"
  task deliver_emails: :environment do

    if Setting.monthly_mail == Date.today.day
      members = Member.where.not(email: '')

      members.each do |member|
        I18n.with_locale(:de) do
          BudgetMailer.mail_to_member(member).deliver_later
        end
      end
    end
  end

  desc "Send emails to report subscribers"
  task deliver_emails_to_report_subscribers: :environment do
    reports = Reporter.where('interval LIKE ?', "#{Date.today.day}")
    unless reports.empty?
      reports.each do |report|

        I18n.with_locale(:de) do
          ReportMailer.mail_to_subscribers(report).deliver_later
        end
      end
    end
  end

end
