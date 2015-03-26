require 'rails_helper'

describe "training without cards" do
  before :all do
    Card.destroy_all
    Card.create(original_text: 'дом', translated_text: 'house')
  end

  it 'no cards' do
    visit root_path
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end
end

describe "training with some cards" do
  before :all do
    Card.destroy_all
    card = Card.create(original_text: 'дом', translated_text: 'house')
    card.update_attribute(:review_date, Time.now)
    card = Card.create(original_text: 'дом', translated_text: 'house')
    card.update_attribute(:review_date, Time.now)
  end

  it 'first visit' do
    visit root_path
    expect(page).to have_content 'Original text'
  end

  it 'incorrect translation' do
    visit root_path
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    visit root_path
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
  end
end

describe "training with one card" do
  before :all do
    Card.destroy_all
    card = Card.create(original_text: 'дом', translated_text: 'house')
    card.update_attribute(:review_date, Time.now)
  end

  it 'first visit' do
    visit root_path
    expect(page).to have_content 'Original text'
  end

  it 'incorrect translation' do
    visit root_path
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    visit root_path
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end
end
