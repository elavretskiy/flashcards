module TrainerHelper
  def check_translation(user_translation)
    visit root_path
    fill_in 'user_translation', with: user_translation
    click_button 'Проверить'
  end

  def create_review_cards
    (0..1).each do
      card = create(:card)
      card.update_attribute(:review_date, Time.now)
    end
  end

  def create_review_card
    card = create(:card)
    card.update_attribute(:review_date, Time.now)
  end
end