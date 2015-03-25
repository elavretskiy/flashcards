class TrainerController < ApplicationController
  respond_to :html

  def review
    @card = Card.find(params[:id])
    if @card.check_user_translation(trainer_params[:user_translation])
      flash[:alert] = 'Вы ввели верный перевод. Продолжайте.'
      redirect_to root_path
    else
      flash[:alert] = 'Вы ввели не верный перевод. Повторите попытку.'
      render 'home/index'
    end
  end

  private
  def trainer_params
    params.permit(:user_translation)
  end
end
