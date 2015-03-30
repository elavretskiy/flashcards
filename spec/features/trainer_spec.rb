require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'review cards' do
  describe 'training without cards' do
    before do
      create(:user_with_cards)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training with some cards' do
    before do
      user = create(:user_with_cards, cards_count: 2)
      user.cards.each { |card| card.update_attribute(:review_date,
                                                     Time.now - 3.days) }
      visit root_path
      login('test@test.com', '12345')
    end

    it 'first visit' do
      expect(page).to have_content 'Оригинал'
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

  describe 'training with one card' do
    before do
      user = create(:user_with_cards)
      user.cards.each { |card| card.update_attribute(:review_date,
                                                     Time.now - 3.days) }
      visit root_path
      login('test@test.com', '12345')
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