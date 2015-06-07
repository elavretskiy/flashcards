News::ArticlesController.class_eval do
  before_action :require_login, only: [:destroy, :edit, :update, :new, :create, :admin]
  authorize_resource
  skip_authorize_resource only: [:index, :show]

  layout 'layouts/application'

  private

  def not_authenticated
    redirect_to main_app.login_path, alert: t(:please_log_in)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to news.articles_path, :alert => exception.message
  end
end
