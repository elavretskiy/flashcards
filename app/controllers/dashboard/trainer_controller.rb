class Dashboard::TrainerController < Dashboard::BaseController
  before_action :set_card, only: [:review_card]
  respond_to :js, :html

  def index
    if params[:card_id]
      set_card
    else
      if current_user.current_block
        @card = current_user.current_block.cards.pending.first
        @card ||= current_user.current_block.cards.repeating.first
      else
        @card = current_user.cards.pending.first
        @card ||= current_user.cards.repeating.first
      end
    end
  end

  def review_card
    check_result = @card.check_translation(trainer_params[:user_translation])

    if check_result[:state]
      if check_result[:distance] == 0
        flash[:notice] = t(:correct_translation_notice)
      else
        flash[:alert] = t 'translation_from_misprint_alert',
                          user_translation: trainer_params[:user_translation],
                          original_text: @card.original_text,
                          translated_text: @card.translated_text
      end
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(card_id: @card.id)
    end
  end

  private

  def set_card
    @card = current_user.cards.find(params[:card_id])
  end

  def trainer_params
    params.require(:review_card).permit(:user_translation)
  end
end
