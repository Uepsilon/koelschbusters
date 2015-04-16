class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.noreply_email
end
