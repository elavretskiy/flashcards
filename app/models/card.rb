class Card < ActiveRecord::Base
  before_validation :set_review
  validate :check_original_translated_equal
  validates :original, presence: true
  validates :translated, presence: true
  validates :review, presence: true

  protected
    def set_review
      self.review = Time.now + 3.days
    end

    def check_original_translated_equal
      self.original = original.mb_chars.downcase.to_s.squeeze(' ').lstrip
      self.translated = translated.mb_chars.downcase.to_s.squeeze(' ').lstrip
      if original == translated
        errors.add(:original,
                   ' = Translated. Вводимые значения должны отличаться.')
      end
    end
end
