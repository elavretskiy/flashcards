class ProfileController < ApplicationController
  respond_to :html

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path,
                  notice: 'Профиль пользователя успешно обновлен.'
    else
      respond_with @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
