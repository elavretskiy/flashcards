class Card < ActiveRecord::Base
  before_validation :set_review_date, on: :create
  validate :original_translated_text_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }

  scope :review_card, -> { where('review_date <= ?', Time.now.strftime('%Y-%m-%d')).order('RANDOM()') }

  def check_user_translation(user_translation)
    set_review_date if translated_text == user_translation.downcase
  end

  protected
    def set_review_date
      self.review_date = Time.now + 3.days
    end

    def original_translated_text_equal
      self.original_text = full_downcase(original_text)
      self.translated_text = full_downcase(translated_text)
      if original_text == translated_text
        errors.add(:original_text, 'Вводимые значения должны отличаться.')
      end
    end

    def full_downcase(str)
      str.mb_chars.downcase.to_s.squeeze(' ').lstrip
    end
end
