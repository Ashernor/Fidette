# encoding: utf-8
class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "fidette@fidzup.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def new_debt_email(email, sender, value)
    @sender = sender
    @value = value
    mail(:to => email, :subject => "Nouvelle dette")
  end

  def new_credit_email(email, sender, value)
    @sender = sender
    @value = value
    mail(:to => email, :subject => "Nouvelle créance")
  end

  def warn_creditor_email(email, debtor, value, title)
    @debtor = debtor
    @value = value
    @name = title
    mail(:to => email, :subject => "Une dette vous a été réglée")
  end

  def warn_debtor_email(email, creditor, value, title)
    @creditor = creditor
    @value = value
    @title = title
    mail(:to => email, :subject => "Une dette a été soldée")
  end

end
