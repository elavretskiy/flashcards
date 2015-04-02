require 'rails_helper'
require 'support/helpers/trainer_helper.rb'
include TrainerHelper

describe TrainerController do
  describe 'review_card' do
    describe 'correct translation' do
      before do
        @user = create(:user)
        @block = create(:block, user: @user)
        @controller.send(:auto_login, @user)
      end

      it 'set review_date step=1' do
        card = create_and_check_review_card(@user, @block, 1, 'house')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 12.hours).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step step=1' do
        card = create_and_check_review_card(@user, @block, 1, 'house')
        expect(card.review_step).to eq(2)
      end

      it 'set review_date step=2' do
        card = create_and_check_review_card(@user, @block, 2, 'house')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 3.days).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step step=2' do
        card = create_and_check_review_card(@user, @block, 2, 'house')
        expect(card.review_step).to eq(3)
      end

      it 'set review_date step=3' do
        card = create_and_check_review_card(@user, @block, 3, 'house')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 7.days).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step step=3' do
        card = create_and_check_review_card(@user, @block, 3, 'house')
        expect(card.review_step).to eq(4)
      end

      it 'set review_date step=4' do
        card = create_and_check_review_card(@user, @block, 4, 'house')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 14.days).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step step=4' do
        card = create_and_check_review_card(@user, @block, 4, 'house')
        expect(card.review_step).to eq(5)
      end

      it 'set review_date step=5' do
        card = create_and_check_review_card(@user, @block, 5, 'house')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 1.months).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step step=5' do
        card = create_and_check_review_card(@user, @block, 5, 'house')
        expect(card.review_step).to eq(5)
      end
    end

    describe 'incorrect translation' do
      before do
        @user = create(:user)
        @block = create(:block, user: @user)
        @controller.send(:auto_login, @user)
      end

      it 'set review_date try=1' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq(card.review_date.strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=1' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        expect(card.review_step).to eq(3)
      end

      it 'set review_count try=1' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        expect(card.review_attempt).to eq(2)
      end

      it 'set review_date try=2' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq(card.review_date.strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=2' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 1)
        expect(card.review_step).to eq(3)
      end

      it 'set review_count try=2' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 1)
        expect(card.review_attempt).to eq(3)
      end

      it 'set review_date try=3' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq(card.review_date.strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=3' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        expect(card.review_step).to eq(1)
      end

      it 'set review_count try=3' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        expect(card.review_attempt).to eq(1)
      end

      it 'set review_date try=4' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 3)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq(card.review_date.strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=4' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 3)
        expect(card.review_step).to eq(1)
      end

      it 'set review_count try=4' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 3)
        expect(card.review_attempt).to eq(2)
      end
    end

    describe 'incorrect and correct translation' do
      before do
        @user = create(:user)
        @block = create(:block, user: @user)
        @controller.send(:auto_login, @user)
      end

      it 'set review_date try=3' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 1)
        card = check_review_card(card, 'house', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 7.days).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=3' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 1)
        card = check_review_card(card, 'house', 1)
        expect(card.review_step).to eq(4)
      end

      it 'set review_count try=3' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 1)
        card = check_review_card(card, 'house', 1)
        expect(card.review_attempt).to eq(1)
      end

      it 'set review_date try=4' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        card = check_review_card(card, 'house', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 12.hours).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=4' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        card = check_review_card(card, 'house', 1)
        expect(card.review_step).to eq(2)
      end

      it 'set review_count try=4' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        card = check_review_card(card, 'house', 1)
        expect(card.review_attempt).to eq(1)
      end

      it 'set review_date try=4+1' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        card = check_review_card(card, 'house', 1)
        card = create_and_check_review_card(@user, @block, 1, 'house')
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 12.hours).strftime('%Y-%m-%d %H:%M'))
      end

      it 'set review_step try=4+1' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        card = check_review_card(card, 'house', 1)
        card = create_and_check_review_card(@user, @block, 1, 'house')
        expect(card.review_step).to eq(2)
      end

      it 'set review_count try=4+1' do
        card = create_and_check_review_card(@user, @block, 3, 'car')
        card = check_review_card(card, 'car', 2)
        card = check_review_card(card, 'house', 1)
        card = create_and_check_review_card(@user, @block, 1, 'house')
        expect(card.review_attempt).to eq(1)
      end
    end
  end
end
