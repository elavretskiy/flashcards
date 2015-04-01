require 'rails_helper'

describe Card do
  it 'create card with empty original text' do
    card = Card.create(original_text: '', translated_text: 'house', user_id: 1,
                       block_id: 1)
    expect(card.errors[:original_text]).to include('Необходимо заполнить поле.')
  end

  it 'create card with empty translated text' do
    card = Card.create(original_text: 'дом', translated_text: '', user_id: 1,
                       block_id: 1)
    expect(card.errors[:translated_text]).
        to include('Необходимо заполнить поле.')
  end

  it 'create card with empty texts' do
    card = Card.create(original_text: '', translated_text: '', user_id: 1,
                       block_id: 1)
    expect(card.errors[:original_text]).
        to include('Вводимые значения должны отличаться.')
  end

  it 'equal_texts Eng' do
    card = Card.create(original_text: 'house', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.errors[:original_text]).
        to include('Вводимые значения должны отличаться.')
  end

  it 'equal_texts Rus' do
    card = Card.create(original_text: 'дом', translated_text: 'дом', user_id: 1,
                       block_id: 1)
    expect(card.errors[:original_text]).
        to include('Вводимые значения должны отличаться.')
  end

  it 'full_downcase Eng' do
    card = Card.create(original_text: 'hOuse', translated_text: 'houSe',
                       user_id: 1, block_id: 1)
    expect(card.errors[:original_text]).
        to include('Вводимые значения должны отличаться.')
  end

  it 'full_downcase Rus' do
    card = Card.create(original_text: 'Дом', translated_text: 'доМ', user_id: 1,
                       block_id: 1)
    expect(card.errors[:original_text]).
        to include('Вводимые значения должны отличаться.')
  end

  it 'create card original_text OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.original_text).to eq('дом')
  end

  it 'create card translated_text OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.translated_text).to eq('house')
  end

  it 'create card errors OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.errors.any?).to be false
  end

  it 'set_review_date OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.review_date.strftime('%Y-%m-%d')).
        to eq(Time.now.strftime('%Y-%m-%d'))
  end

  it 'check_translation Eng OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('house')).to be true
  end

  it 'check_translation Eng NOT' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('RoR')).to be false
  end

  it 'check_translation Rus OK' do
    card = Card.create(original_text: 'house', translated_text: 'дом',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('дом')).to be true
  end

  it 'check_translation Rus NOT' do
    card = Card.create(original_text: 'house', translated_text: 'дом',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('RoR')).to be false
  end

  it 'check_translation full_downcase Eng OK' do
    card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('HousE')).to be true
  end

  it 'check_translation full_downcase Eng NOT' do
    card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('RoR')).to be false
  end

  it 'check_translation full_downcase Rus OK' do
    card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('дОм')).to be true
  end

  it 'check_translation full_downcase Rus NOT' do
    card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ',
                       user_id: 1, block_id: 1)
    expect(card.check_translation('RoR')).to be false
  end

  it 'create card witout user_id' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       block_id: 1)
    expect(card.errors[:user_id]).
        to include('Ошибка ассоциации.')
  end

  it 'create card witout block_id' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1)
    expect(card.errors[:block_id]).
        to include('Выберите колоду из выпадающего списка.')
  end
end
