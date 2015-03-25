class TrainerController < ApplicationController
  before_action :set_card, only: [:review]
  respond_to :html

  def review
    if @card.check_user_translation(params[:user_translation])
      @card.save
      flash[:alert] = 'Вы ввели верный перевод. Продолжайте.'
      redirect_to root_path
    else
      flash[:alert] = 'Вы ввели не верный перевод. Повторите попытку.'
      render '/home/index_form'
    end
  end

  private
  def set_card
    @card = Card.find(params[:card_id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
end
