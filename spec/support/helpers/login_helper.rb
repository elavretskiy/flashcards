module LoginHelper
  def login(email, password)
    click_link 'Войти'
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Войти'
  end

  def registration(email, password, password_confirmation)
    visit new_user_path
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password_confirmation
    click_button 'Сохранить'
  end
end
