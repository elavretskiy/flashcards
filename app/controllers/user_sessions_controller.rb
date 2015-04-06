class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to root_path, notice: t(:log_in_is_successful_notice)
    else
      flash.now[:alert] = t(:not_logged_in_alert)
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: t(:log_out_is_successful_notice)
  end
end
