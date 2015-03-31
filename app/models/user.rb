class User < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_block, class_name: 'Block'

  accepts_nested_attributes_for :authentications

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  validates :password, confirmation: true, presence: true,
            length: { minimum: 3 }
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true, presence: true

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end

  def change_current_block(id, set_as_current)
    if set_as_current
      update_attribute(:current_block_id, id)
    else
      update_attribute(:current_block_id, nil) if id == current_block_id
    end
  end
end