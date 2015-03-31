class HomeController < ApplicationController
  respond_to :html

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      if current_user.current_block
        @card = current_user.current_block.cards.pending.first
      else
        @card = current_user.cards.pending.first
      end
    end
  end
end
