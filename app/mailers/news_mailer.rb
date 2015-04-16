class NewsMailer < ApplicationMailer
  def notification(user, news)
    @news = news
    @user = user

    mail(to: user.email, subject: 'Es wurde ein neuer interner Beitag geschrieben')
  end
end
