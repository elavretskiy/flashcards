module TrainerHelper
  def create_and_check_review_card(user, block, repeat, translate)
    card = create(:card, user: user, block: block, repeat: repeat)
    put :review_card, { card_id: card.id, review_card: { user_translation: translate } }
    Card.find(card.id)
  end

  def check_review_card(card, translate, number)
    number.times {
      put :review_card, { card_id: card.id, review_card: { user_translation: translate } }
    }
    Card.find(card.id)
  end
end
