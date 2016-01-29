class ReportMailer < ApplicationMailer

  def mail_to_subscribers(_report)
    @report = _report
    mail to: @report.emails,
         subject: "[Bericht] #{@report.name} (Darmstad-City)"
  end

end
