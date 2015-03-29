class ProfileController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  respond_to :html

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_profile_path,
                  notice: 'Профиль пользователя успешно обновлен.'
    else
      respond_with @user
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
