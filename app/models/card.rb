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
    if review_attempt < 3
      update_attributes(review_attempt: [review_attempt + 1, 3].min)
    else
      update_attributes(review_step: 1, review_attempt: 1)
    end
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end

  def set_review_date_for_step
    case review_step
    when 1
      update_review_params(Time.now + 12.hours)
    when 2
      update_review_params(Time.now + 3.days)
    when 3
      update_review_params(Time.now + 7.days)
    when 4
      update_review_params(Time.now + 14.days)
    when 5
      update_review_params(Time.now + 1.months)
    end
  end

  def update_review_params(date)
    update_attributes(review_date: date, review_step: [review_step + 1, 5].min,
                      review_attempt: 1)
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
