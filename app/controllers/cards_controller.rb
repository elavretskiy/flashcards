class CardsController < ApplicationController
  before_action :set_card, only: [:destroy, :edit, :update, :check_words]
  respond_to :html

  def index
    @cards = Card.all
    respond_with @cards
  end

  def new
    @card = Card.new
    respond_with @card
  end

  def edit
  end

  def create
    @card = Card.new(card_params)
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

  def check_words
    if @card.translated_text == card_params[:translated_text].downcase
      @card.review_date = Time.now + 3.days
      @card.save
      flash[:alert] = 'Вы ввели верный перевод. Продолжайте.'
      redirect_to controller: :home, action: :index
    else
      flash[:alert] = 'Вы ввели не верный перевод. Повторите попытку.'
      render '/home/index'
    end
  end

  private
    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
end
