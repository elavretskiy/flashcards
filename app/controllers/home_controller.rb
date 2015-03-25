class HomeController < ApplicationController
  respond_to :html

  def index
    @card = Card.review_date_card
    render :index
  end
end
