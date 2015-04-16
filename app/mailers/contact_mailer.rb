# encoding: UTF-8
class ContactMailer < ApplicationMailer
  default to: Rails.application.secrets.contact_email

  def contact_email(details)
    @details = details

    subject = details.subject
    subject = 'Kontaktanfrage' if subject.blank?
    mail(subject: subject)
  end

  def welcome_instructions(user, token)
    @user   = user
    @token  = token

    mail(to: user.email, subject: 'Dein Account für die Webseite der Wahner Kölschbusters')
  end
end
