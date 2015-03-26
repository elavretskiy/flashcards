require 'rails_helper'

describe "training without cards" do
  before :all do
    Card.destroy_all
    Card.create(original_text: 'дом', translated_text: 'house')
    @card = Card.pending.first
  end

  it 'no cards' do
    visit '/'
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end
end

describe "training with some cards" do
  before :each do
    Card.destroy_all
    @card = Card.create(original_text: 'дом', translated_text: 'house')
    @card.update_attribute(:review_date, Time.now)
    @card = Card.create(original_text: 'машина', translated_text: 'car')
    @card.update_attribute(:review_date, Time.now)
    @card = Card.pending.first
  end

  it 'first visit' do
    visit '/'
    expect(page).to have_content 'Original text'
  end

  it 'incorrect translation' do
    visit '/'
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    visit '/'
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
  end
end

describe "training with one card" do
  before :all do
    Card.destroy_all
    @card = Card.create(original_text: 'дом', translated_text: 'house')
    @card.update_attribute(:review_date, Time.now)
    @card = Card.pending.first
  end

  it 'first visit' do
    visit '/'
    expect(page).to have_content 'Original text'
  end

  it 'incorrect translation' do
    visit '/'
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    visit '/'
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end
end
