class HomeController < ApplicationController
  respond_to :html

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      @card = current_user.cards.pending.first
    end
  end
end
