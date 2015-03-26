class Card < ActiveRecord::Base
  before_validation :set_review_date, on: :create
  validate :original_translated_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }

  scope :pending, -> { where('review_date >= ?', Time.now).order('RANDOM()') }

  def check_translation(user_translation)
    if full_downcase(translated_text) == full_downcase(user_translation)
      update_attributes(review_date: Time.now + 3.days)
    end
  end

  protected
  def set_review_date
    self.review_date = Time.now + 3.days
  end

  def original_translated_equal
  if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
