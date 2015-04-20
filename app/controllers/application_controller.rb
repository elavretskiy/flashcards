class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  respond_to :html, :js

  def index
  end

  def invite_friends
    invite_friends = params.require(:invite_friends).permit(:emails)

    emails = invite_friends[:emails]
    emails = emails.gsub(' ', '').split(',')

    if @invite_friends_state = FriendsService.invite(emails)
      flash.now[:notice] = 'Ваши друзья успешно приглашены на сайт.'
    else
      flash.now[:alert] = 'Проверьте формат вводимых данных.'
      flash.now[:notice] = nil
    end
  end

  private

  def set_locale
    locale = if current_user
               current_user.locale
             elsif params[:user_locale]
               params[:user_locale]
             elsif session[:locale]
               session[:locale]
             else
               http_accept_language.compatible_language_from(I18n.available_locales)
             end

    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale
    else
      session[:locale] = I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
