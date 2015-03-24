class CardsController < ApplicationController
  before_action :set_card, only: [:destroy]
  respond_to :html

  def index
    @cards = Card.all
    respond_with @cards
  end

  def new
    @card = Card.new
    respond_with @card
  end

  def create
    @card = Card.new(card_params)
    @card.save ? (redirect_to action: :index) :
        (respond_with @card)
  end

  def destroy
    @card.destroy
    respond_with @card
  end

  private
    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:original, :translated, :review)
    end
end
