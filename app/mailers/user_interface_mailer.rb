class UserInterfaceMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_FROM_CARDS']

  def invite_friends(emails)
    mail(to: emails, subject: "Приглашаем Вас на сайт flashcards.")
  end
end
