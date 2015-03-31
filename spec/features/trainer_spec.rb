require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'review cards without blocks' do
  describe 'training without cards' do
    before do
      create(:user)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end

describe 'review cards with one block' do
  describe 'training without cards' do
    before do
      create(:user_with_one_block_without_cards)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training without review cards' do
    before do
      create(:user_with_one_block_and_two_cards)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training with two cards' do
    before do
      user = create(:user_with_one_block_and_two_cards)
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
      user = create(:user_with_one_block_and_one_card)
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

describe 'review cards with two blocks' do
  describe 'training without cards' do
    before do
      create(:user_with_two_blocks_without_cards)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training without review cards' do
    before do
      create(:user_with_two_blocks_and_one_card_in_each)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training with two cards' do
    before do
      user = create(:user_with_two_blocks_and_one_card_in_each)
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
      user = create(:user_with_two_blocks_and_only_one_card)
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

describe 'review cards with current_block' do
  describe 'training without cards' do
    before do
      create(:user_with_two_blocks_without_cards, current_block: 1)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training without review cards' do
    before do
      user = create(:user_with_two_blocks_and_one_card_in_each)
      block = user.blocks.first
      user.set_current_block(block.id, true)
      block = user.blocks.last
      card = user.cards.find_by(block_id: block.id)
      card.update_attribute(:review_date, Time.now - 3.days)
      visit root_path
      login('test@test.com', '12345')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training with two cards' do
    before do
      user = create(:user_with_two_blocks_and_two_cards_in_each)
      block = user.blocks.first
      user.set_current_block(block.id, true)
      card = user.cards.find_by(block_id: block.id)
      card.update_attribute(:review_date, Time.now - 3.days)
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
      user = create(:user_with_two_blocks_and_one_card_in_each)
      block = user.blocks.first
      user.set_current_block(block.id, true)
      card = user.cards.find_by(block_id: block.id)
      card.update_attribute(:review_date, Time.now - 3.days)
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
