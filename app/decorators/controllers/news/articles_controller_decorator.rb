News::ArticlesController.class_eval do
  before_action :require_login, only: [:destroy, :edit, :update, :new, :create, :admin]
  before_action :authorization, only: [:destroy, :edit, :update, :new, :create, :admin]

  layout 'layouts/application'

  private

  def not_authenticated
    redirect_to main_app.login_path, alert: t(:please_log_in)
  end

  def authorization
    if (current_user.has_role? :admin) || (current_user.has_role? :super) || (current_user.has_role? :newsmaker)
    elsif (current_user.has_role? :user)
      redirect_to news.article_path(params[:id])
    else
      redirect_to news.articles_path, alert: t(:access_error)
    end
  end
end
