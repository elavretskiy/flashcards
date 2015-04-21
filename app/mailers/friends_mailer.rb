class FriendsMailer < ActionMailer::Base
  layout 'mailers'

  unless Rails.env.test? || Rails.env.cucumber?
    default from: ENV['DEFAULT_EMAIL_FROM_CARDS']
  else
    default from: 'info@flashcards.com'
  end

  def invite(email)
    mail(to: email, subject: 'Приглашаем Вас на сайт flashcards.')
  end
end
