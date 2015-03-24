class Card < ActiveRecord::Base
  before_create :set_review
  validate :check_card

  protected
    def set_review
      self.review = Time.now + 3.days
    end

    def check_card
      self.original = original.downcase
      self.translated = translated.downcase
      errors.add(:original, ' = Translated. Вводимые значения должны отличаться.') if
          original == translated
    end
end
