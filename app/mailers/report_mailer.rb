class ReportMailer < ApplicationMailer

  def mail_to_subscribers(_report)
    @report = _report
    mail bcc: @report.emails,
         subject: "[Darmstadt-City] #{t('reporter.title')}: #{@report.name}"
  end

end
