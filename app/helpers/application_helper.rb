module ApplicationHelper
  def email_antispam(email)
    email.gsub(/@/,'[at]').gsub(/\./, '[dot]')
  end
end
