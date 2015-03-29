require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'password authentication' do
  describe 'authentication' do
    before do
      create(:user)
      visit root_path
    end

    it 'require_login root' do
      expect(page).to have_content 'Пожалуйста авторизуйтесь.'
    end

    it 'authentication TRUE' do
      login('test@test.com', '12345')
      expect(page).to have_content 'Вход успешно выполнен.'
    end

    it 'incorrect e-mail' do
      login('1@1.com', '12345')
      expect(page).
          to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
    end

    it 'incorrect password' do
      login('test@test.com', '56789')
      expect(page).
          to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
    end

    it 'incorrect e-mail and password' do
      login('1@1.com', '56789')
      expect(page).
          to have_content 'Вход не выполнен. Проверте вводимые E-mail и Пароль.'
    end
  end

  describe 'registration' do
    before do
      visit root_path
    end

    it 'registration TRUE' do
      registration('test@test.com', '12345', '12345')
      expect(page).to have_content 'Пользователь успешно создан.'
    end

    it 'password confirmation FALSE' do
      registration('test@test.com', '12345', '56789')
      expect(page).to have_content "doesn't match Password"
    end

    it 'e-mail FALSE' do
      registration('test', '12345', '12345')
      expect(page).to have_content 'Пользователь успешно создан.'
    end

    it 'e-mail has already been taken' do
      registration('test@test.com', '12345', '12345')
      registration('test@test.com', '12345', '12345')
      expect(page).to have_content 'has already been taken'
    end

    it 'password is too short' do
      registration('test@test.com', '1', '12345')
      expect(page).to have_content 'is too short (minimum is 3 characters)'
    end

    it 'password_confirmation is too short' do
      registration('test@test.com', '12345', '1')
      expect(page).to have_content "doesn't match Password"
    end
  end
end