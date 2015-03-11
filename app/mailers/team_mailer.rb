class TeamMailer < ActionMailer::Base
  default from:   Rails.application.secrets.noreply_email

  def comment_reminder(user, inactive_comment_count)
    @inactive_comment_count = inactive_comment_count
    @user                   = user

    mail(to: user.email, subject: "Es gibt noch nicht aktivierte Kommentare.")
  end
end
