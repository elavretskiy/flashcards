class CardsController < ApplicationController
  before_action :set_card, only: [:destroy, :edit, :update]
  before_action :set_user, only: [:index, :create, :update]
  respond_to :html

  def index
    @cards = @user.cards.all
    respond_with @cards
  end

  def new
    @card = Card.new
    respond_with @card
  end

  def edit
  end

  def create
    @card = @user.cards.build(card_params)
    if @card.save
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def destroy
    @card.destroy
    respond_with @card
  end

  private
  def set_card
    set_user
    @card = @user.cards.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
end
