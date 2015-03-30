class Card < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  before_validation :set_review_date, on: :create
  validate :texts_are_not_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }

  scope :pending, -> { where('review_date <= ?', Time.now).order('RANDOM()') }

  mount_uploader :image, CardImageUploader

  def check_translation(user_translation)
    if full_downcase(translated_text) == full_downcase(user_translation)
      update_attributes(review_date: Time.now + 3.days)
    else
      false
    end
  end

  protected

  def set_review_date
    self.review_date = Time.now + 3.days
  end

  def texts_are_not_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
