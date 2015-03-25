class Card < ActiveRecord::Base
  before_validation :set_review_date, on: :create
  before_save :set_downcase_text
  validate :original_translated_text_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }

  def self.pending(id)
    if id
      where('review_date <= ? AND id = ?', Time.now, id).order('RANDOM()')
    else
      where('review_date <= ?', Time.now).order('RANDOM()')
    end
  end

  def check_user_translation(user_translation)
    if translated_text == user_translation.downcase
      update_attributes(review_date: Time.now + 3.days)
    end
  end

  protected
  def set_review_date
    self.review_date = Time.now + 3.days
  end

  def original_translated_text_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end

  def set_downcase_text
    self.original_text = full_downcase(original_text)
    self.translated_text = full_downcase(translated_text)
  end
end
