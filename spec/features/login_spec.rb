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
      expect(page).to have_content 'Вход выполнен успешно.'
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

  describe 'register' do
    before do
      visit root_path
    end

    it 'register TRUE' do
      register('test@test.com', '12345', '12345')
      expect(page).to have_content 'Пользователь успешно создан.'
    end

    it 'password confirmation FALSE' do
      register('test@test.com', '12345', '56789')
      expect(page).to have_content "Значения не совпадают."
    end

    it 'e-mail FALSE' do
      register('test', '12345', '12345')
      expect(page).to have_content 'Пользователь успешно создан.'
    end

    it 'e-mail has already been taken' do
      register('test@test.com', '12345', '12345')
      register('test@test.com', '12345', '12345')
      expect(page).to have_content 'Не уникальное значение.'
    end

    it 'password is too short' do
      register('test@test.com', '1', '12345')
      expect(page).to have_content 'Короткое значение.'
    end

    it 'password_confirmation is too short' do
      register('test@test.com', '12345', '1')
      expect(page).to have_content 'Значения не совпадают.'
    end
  end
end
