class FriendsMailer < ActionMailer::Base
  layout 'mailers'

  def invite(email)
    mail(to: email, subject: 'Приглашаем Вас на сайт flashcards.')
  end
end
