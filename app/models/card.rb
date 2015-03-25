class Card < ActiveRecord::Base
  before_validation :set_review_date, on: :create
  validate :original_translated_text_equal
  validates :original_text, :translated_text, :review_date, presence: true

  protected
    def set_review_date
      self.review_date = Time.now + 3.days
    end

    def original_translated_text_equal
      self.original_text = original_text.mb_chars.downcase.to_s.squeeze(' ').lstrip
      self.translated_text = translated_text.mb_chars.downcase.to_s.squeeze(' ').lstrip
      if original_text == translated_text
        errors.add(:original_text, ' = Translated text. Вводимые значения должны отличаться.')
      end
    end
end
