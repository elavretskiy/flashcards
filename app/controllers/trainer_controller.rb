class TrainerController < ApplicationController
  respond_to :html

  def review_card
    @card = current_user.cards.find(params[:card_id])

    levenshtein_distance =
        @card.check_translation(trainer_params[:user_translation])

    case levenshtein_distance
      when 0
        flash[:notice] = 'Вы ввели верный перевод. Продолжайте.'
        redirect_to root_path
      when 1
        flash[:alert] =
            "Вы ввели перевод c опечаткой.
          Ваш вариант: #{trainer_params[:user_translation]} /
          Оригинал: #{@card.original_text} /
          Перевод: #{@card.translated_text}. Продолжайте."
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
