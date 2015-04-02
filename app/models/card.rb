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
    levenshtein_distance = Levenshtein.distance(full_downcase(translated_text),
                                                full_downcase(user_translation))

    if levenshtein_distance <= 1
      set_review_date_for_step
      levenshtein_distance
    else
      reset_review_step
      nil
    end
  end

  protected

  def reset_review_step
    if review_attempt < 3
      update_attributes(review_attempt: [review_attempt + 1, 3].min)
    else
      update_attributes(review_step: 1, review_attempt: 1)
    end
  end

  def set_review_date_as_now
    self.review_date = Time.now
  end

  def set_review_date_for_step
    review_date_shift = case review_step
                        when 1 then 12.hours
                        when 2 then 3.days
                        when 3 then 7.days
                        when 4 then 14.days
                        when 5 then 1.months
                        end
    update_review_params(Time.now + review_date_shift)
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
