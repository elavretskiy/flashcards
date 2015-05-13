class Block < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :user

  validates :title, presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }

  def current?
    id == user.current_block_id
  end
end
