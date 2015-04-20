class Dashboard::ProfileController < Dashboard::BaseController
  respond_to :html, :js

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path,
                  notice: 'Профиль пользователя успешно обновлен.'
    else
      respond_with current_user
    end
  end

  def invite_friends
    @incorrect_emails = FriendsService.invite(invite_friends_params[:emails])
    if @incorrect_emails.blank?
      flash.now[:notice] = 'Ваши друзья успешно приглашены на сайт.'
    else
      flash.now[:alert] = 'Проверьте формат вводимых данных: ' + @incorrect_emails + '.'
      flash.now[:notice] = nil
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :locale)
  end

  def invite_friends_params
    parameters = params.require(:invite_friends).permit(:emails)
    parameters[:emails] = parameters[:emails].gsub(' ', '').split(',')
    parameters
  end
end
