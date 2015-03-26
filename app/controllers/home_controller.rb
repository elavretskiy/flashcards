class HomeController < ApplicationController
  respond_to :html

  def index
    if params[:id]
      @card = Card.find(params[:id])
    else
      @card = Card.pending.first
    end
  end
end
