class HomeController < ApplicationController
  respond_to :html

  def index
    @card = Card.pending(params[:id]).first
  end
end
