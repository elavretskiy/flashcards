require 'rails_helper'

describe "review cards" do
  describe "training without cards" do
    before do
      create(:card)
      visit root_path
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe "training with some cards" do
    before do
      2.times do
        card = create(:card)
        card.update_attribute(:review_date, Time.now)
        visit root_path
      end
    end

    it 'first visit' do
      expect(page).to have_content 'Original text'
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end
  end

  describe "training with one card" do
    before do
      card = create(:card)
      card.update_attribute(:review_date, Time.now)
      visit root_path
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end