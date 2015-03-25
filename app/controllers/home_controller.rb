class HomeController < ApplicationController
  respond_to :html

  def index
    @card = Card.review_card.first
    render :index
  end
end
