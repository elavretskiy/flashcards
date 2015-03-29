class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
  before_action :set_user, only: [:destroy]
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

  def destroy
    current_user.destroy
    redirect_to login_path, notice: 'Пользователь успешно удален.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
