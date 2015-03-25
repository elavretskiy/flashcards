class TrainerController < ApplicationController
  before_action :set_card, only: [:review]
  respond_to :html

  def review
    if @card.check_user_translation(trainer_params[:user_translation])
      flash[:alert] = 'Вы ввели верный перевод. Продолжайте.'
      redirect_to root_path
    else
      flash[:alert] = 'Вы ввели не верный перевод. Повторите попытку.'
      redirect_to root_path(card_id: @card.id)
    end
  end

  private
  def set_card
    @card = Card.find(params[:id])
  end

  def trainer_params
    params.permit(:user_translation)
  end
end
