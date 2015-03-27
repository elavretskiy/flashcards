require 'rails_helper'
require 'support/helpers/trainer_helper.rb'
include TrainerHelper

describe "training without cards" do
  before :each do
    create(:card)
  end

  it 'no cards' do
    visit root_path
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end
end

describe "training with some cards" do
  before :each do
    create_review_cards
  end

  it 'first visit' do
    visit root_path
    expect(page).to have_content 'Original text'
  end

  it 'incorrect translation' do
    check_translation('RoR')
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    check_translation('house')
    expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
  end
end

describe "training with one card" do
  before :each do
    create_review_card
  end

  it 'first visit' do
    visit root_path
    expect(page).to have_content 'Original text'
  end

  it 'incorrect translation' do
    check_translation('RoR')
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    check_translation('house')
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end
end
