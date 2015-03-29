class OauthsController < ApplicationController
  skip_before_filter :require_login
  before_filter :require_login, only: :destroy

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path,
                  notice:
                      "Вход из аккаунта #{provider.titleize} выполнен успешно."
    else
      begin
        @user = create_from(provider)
        # NOTE: this is the place to add '@user.activate!'
        # if you are using user_activation submodule

        reset_session
        auto_login(@user)
        redirect_to root_path,
                    notice:
                        "Вход из аккаунта #{provider.titleize} выполнен успешно."
      rescue
        redirect_to root_path,
                    alert: "Вход из аккаунта #{provider.titleize} не выполнен ."
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end