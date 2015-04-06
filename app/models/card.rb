require 'super_memo'

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
  validates :interval, :repeat, :efactor, :quality, :attempt, presence: true

  mount_uploader :image, CardImageUploader

  scope :pending, -> { where('review_date <= ?', Time.now).order('RANDOM()') }
  scope :repeating, -> { where('quality < ?', 4).order('RANDOM()') }

  def check_translation(user_translation)
    distance = Levenshtein.distance(full_downcase(translated_text),
                                    full_downcase(user_translation))

    sm_hash = SuperMemo.new.algorithm(interval, repeat, efactor, set_quality(distance))

    card_params = if distance <= 1
                    { review_date: Time.now + interval.to_i.days, attempt: 1 }
                  else
                    { attempt: [attempt + 1, 5].min }
                  end

    update(card_params.merge(sm_hash))

    if distance <= 1
      { state: true, distance: distance }
    else
      { state: false, distance: distance }
    end
  end

  def self.pending_cards_notification
    users = User.where.not(email: nil)
    users.each do |user|
      if user.cards.pending.any?
        CardsMailer.pending_cards_notification(user.email).deliver
      end
    end
  end

  protected

  def set_quality(distance)
    self.quality = if distance <= 1
                     case attempt
                     when 1 then 5
                     when 2 then 4
                     else 3
                     end
                   else
                     case attempt
                     when 1 then 2
                     when 2 then 1
                     else 0
                     end
                   end
  end

  def set_review_date_as_now
    self.review_date = Time.now
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
