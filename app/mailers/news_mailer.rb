class NewsMailer < ActionMailer::Base
  default from:   Rails.application.secrets.noreply_email

  def notification(user, news)
    @news = news
    @user = user

    mail(to: user.email, subject: 'Es wurde ein neuer interner Beitag geschrieben')
  end
end
