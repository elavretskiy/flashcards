class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
  def not_authenticated
    redirect_to login_path, alert: 'Пожалуйста авторизуйтесь.'
  end

  def not_found
    flash[:alert] = 'Вы обратились к несуществующей записи.'
    redirect_to root_path
  end
end
