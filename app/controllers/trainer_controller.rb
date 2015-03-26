class TrainerController < ApplicationController
  respond_to :html

  def review
    @card = Card.find(params[:id])
    if @card.check_translation(trainer_params[:user_translation])
      flash[:alert] = 'Вы ввели верный перевод. Продолжайте.'
      redirect_to root_path
    else
      flash[:alert] = 'Вы ввели не верный перевод. Повторите попытку.'
      redirect_to root_path(id: @card.id)
    end
  end

  private
  def trainer_params
    params.permit(:user_translation)
  end
end
