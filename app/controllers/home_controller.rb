class HomeController < ApplicationController
  respond_to :html

  def index
    @user = current_user
    if params[:id]
      @card = @user.cards.find(params[:id])
    else
      @card = @user.cards.pending.first
    end
  end
end
