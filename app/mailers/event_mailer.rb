class EventMailer < ApplicationMailer
  def notify(user, event)
    @event = event
    @user = user

    mail to: user.email, subject: 'Ein neuer Termin wurde eingestellt'
  end
end
