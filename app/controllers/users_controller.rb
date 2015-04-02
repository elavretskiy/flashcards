class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: 'Пользователь успешно создан.'
    else
      respond_with @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
