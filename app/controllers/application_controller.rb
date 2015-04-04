class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  protect_from_forgery with: :exception
  before_action :set_locale
  before_filter :require_login

  private

  def set_locale
    if current_user
      if current_user.locale.empty?
        I18n.locale = http_accept_language.
            compatible_language_from(I18n.available_locales)
      else
        I18n.locale = current_user.locale
      end
    else
      if params[:user_locale]
        I18n.locale = params[:user_locale]
        session[:user_locale] = params[:user_locale]
      elsif !session[:user_locale]
        I18n.locale = http_accept_language.
            compatible_language_from(I18n.available_locales)
      end
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def not_authenticated
    redirect_to login_path, alert: 'Пожалуйста авторизуйтесь.'
  end

  def not_found
    flash[:alert] = 'Вы обратились к несуществующей записи.'
    redirect_to root_path
  end
end
