class HomeController < ApplicationController
  respond_to :html

  def index
    @card = Card.review_card.first
    @card ? (render :index_form) : (render :index)
  end
end
