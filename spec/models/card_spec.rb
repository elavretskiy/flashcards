require 'rails_helper'

RSpec.describe Card, type: :model do
  it 'create card with empty original text' do
    card = Card.create(original_text: '', translated_text: 'house')
    expect(card.errors[:original_text]).to include('Необходимо заполнить поле.')
  end

  it 'create card with empty translated text' do
    card = Card.create(original_text: 'дом', translated_text: '')
    expect(card.errors[:translated_text]).to include('Необходимо заполнить поле.')
  end

  it 'create card with empty texts' do
    card = Card.create(original_text: '', translated_text: '')
    expect(card.errors[:original_text]).to include('Вводимые значения должны отличаться.')
    expect(card.errors[:original_text]).to include("Необходимо заполнить поле.")
    expect(card.errors[:translated_text]).to include("Необходимо заполнить поле.")
  end

  it 'equal_texts Eng' do
    card = Card.create(original_text: 'house', translated_text: 'house')
    expect(card.errors[:original_text]).to include('Вводимые значения должны отличаться.')
  end

  it 'equal_texts Rus' do
    card = Card.create(original_text: 'дом', translated_text: 'дом')
    expect(card.errors[:original_text]).to include('Вводимые значения должны отличаться.')
  end

  it 'full_downcase Eng' do
    card = Card.create(original_text: 'hOuse', translated_text: 'houSe')
    expect(card.errors[:original_text]).to include('Вводимые значения должны отличаться.')
  end

  it 'full_downcase Rus' do
    card = Card.create(original_text: 'Дом', translated_text: 'доМ')
    expect(card.errors[:original_text]).to include('Вводимые значения должны отличаться.')
  end

  it 'create card OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house')
    expect(card.errors[:original_text]).to_not include('Вводимые значения должны отличаться.')
    expect(card.errors[:translated_text]).to_not include("Необходимо заполнить поле.")
    expect(card.errors[:original_text]).to_not include("Необходимо заполнить поле.")
    expect(card.translated_text).to eq('house')
    expect(card.original_text).to eq('дом')
  end

  it 'set_review_date OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house')
    expect(card.errors[:review_date]).to_not include("Необходимо заполнить поле.")
    expect(card.review_date.to_s).to eq((Time.now + 3.days).strftime('%Y-%m-%d'))
  end

  it 'check_translation Eng OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house')
    expect(card.check_translation('house')).to be true
  end

  it 'check_translation Eng NOT' do
    card = Card.create(original_text: 'дом', translated_text: 'house')
    expect(card.check_translation('RoR')).to be nil
  end

  it 'check_translation Rus OK' do
    card = Card.create(original_text: 'house', translated_text: 'дом')
    expect(card.check_translation('дом')).to be true
  end

  it 'check_translation Rus NOT' do
    card = Card.create(original_text: 'house', translated_text: 'дом')
    expect(card.check_translation('RoR')).to be nil
  end

  it 'check_translation full_downcase Eng OK' do
    card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe')
    expect(card.check_translation('HousE')).to be true
  end

  it 'check_translation full_downcase Eng NOT' do
    card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe')
    expect(card.check_translation('RoR')).to be nil
  end

  it 'check_translation full_downcase Rus OK' do
    card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ')
    expect(card.check_translation('дОм')).to be true
  end

  it 'check_translation full_downcase Rus NOT' do
    card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ')
    expect(card.check_translation('RoR')).to be nil
  end
end
