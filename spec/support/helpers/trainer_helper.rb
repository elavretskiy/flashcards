module TrainerHelper
  def create_and_check_review_card(user, block, review_step, translate)
    card = create(:card, user: user, block: block, review_step: review_step)
    put :review_card, { card_id: card.id, user_translation: translate }
    Card.find(card.id)
  end

  def check_review_card(card, translate, number)
    number.times {
      put :review_card, { card_id: card.id, user_translation: translate }
    }
    Card.find(card.id)
  end
end
