class CardsMailer < ActionMailer::Base
  layout 'mailers'

  def pending_cards_notification(email)
    mail(to: email, subject: 'Наступила даты пересмотра карточек.')
  end
end
