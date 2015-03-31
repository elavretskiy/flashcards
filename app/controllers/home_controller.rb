class HomeController < ApplicationController
  respond_to :html

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      @card = current_user.cards.pending(current_user.current_block).first
    end
  end
end
