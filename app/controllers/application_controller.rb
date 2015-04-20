class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  respond_to :html, :js

  def index
  end

  def invite_friends
    emails = params[:emails].delete ' '
    emails = emails.split(',')
    emails.each do |email|
      if !email[/\A([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})\z/i]
        flash.now[:alert] = 'Проверьте формат вводимых данных.'
        flash.now[:notice] = nil
      end
    end

    unless flash[:alert]
      UserInterfaceMailer.invite_friends(params[:emails]).deliver
      flash.now[:notice] = 'Ваши друзья успешно приглашены на сайт.'
      @attr_class = ''
    else
      @attr_class = 'field_with_errors'
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
