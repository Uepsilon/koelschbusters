module ApplicationHelper
  def self.email_antispam email
    email.gsub(/@/,"[at]").gsub(/\./, "[dot]")
  end
end
