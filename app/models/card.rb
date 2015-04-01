class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :block
  validates :user_id, presence: true
  before_validation :set_review_date_as_now, on: :create
  validate :texts_are_not_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }

  mount_uploader :image, CardImageUploader

  scope :pending, -> { where('review_date <= ?', Time.now).order('RANDOM()') }

  def check_translation(user_translation)
    if full_downcase(translated_text) == full_downcase(user_translation)
      set_review_date_for_step
    else
      false
    end
  end

  def reset_review_step
    update_attributes(review_step: 1)
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end

  def set_review_date_for_step
    case review_step
      when 1
        update_attributes(review_date: Time.now + 12.hours,
                          review_step: review_step + 1)
      when 2
        update_attributes(review_date: Time.now + 3.days,
                          review_step: review_step + 1)
      when 3
        update_attributes(review_date: Time.now + 7.days,
                          review_step: review_step + 1)
      when 4
        update_attributes(review_date: Time.now + 14.days,
                          review_step: review_step + 1)
      when 5
        update_attributes(review_date: Time.now + 1.months)
    end
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
