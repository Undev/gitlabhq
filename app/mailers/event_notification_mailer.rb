class EventNotificationMailer < ActionMailer::Base
  default from: Gitlab.config.gitlab.email_from

  # Just send email with 3 seconds delay
  def self.delay
    delay_for(2.seconds)
  end

  #
  # Default email
  #

  def default_email(notification)
    mail(to: "test@email.com", subject: "Undefined mail")
  end
end