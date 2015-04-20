class FriendsMailer < ActionMailer::Base
  layout 'mailers'
  default from: ENV['DEFAULT_EMAIL_FROM_CARDS']

  def invite(email)
    mail(to: email, subject: 'Приглашаем Вас на сайт flashcards.')
  end
end
