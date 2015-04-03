class CardsMailer < ActionMailer::Base
  default from: 'info@flashcards.com'

  def pending_cards_notification(email)
    mail(to: email,
         subject: 'Наступила даты пересмотра карточек.')
  end
end
