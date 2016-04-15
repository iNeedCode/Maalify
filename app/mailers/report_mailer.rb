class ReportMailer < ApplicationMailer

  def mail_to_subscribers(_report)
    @report = _report

    if (@report.tanzeems & %W(Khuddam Atfal Ansar)).present?
      reply_address = Setting.reply_to_male
      @contact_block = 'male'
    elsif (@report.tanzeems & %W(Nasirat Lajna)).present?
      reply_address = Setting.reply_to_female
      @contact_block = 'female'
    elsif ((@report.tanzeems & %W(All)).present? & Donation.where(id: @report.donations).map(&:organization).all? { |o| o == "Lajna" || o == "Nasirat" })
      reply_address = Setting.reply_to_female
      @contact_block = 'female'
    else
      reply_address = Setting.reply_to_male
      @contact_block = 'male'
    end

    mail bcc: @report.emails,
         reply_to: reply_address,
         subject: "[#{Setting.jamaat}] #{t('reporter.title')}: #{@report.name}"
  end

end
