class User < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_block, class_name: 'Block'
  before_validation :set_locale_as_default, on: :create

  accepts_nested_attributes_for :authentications

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  validates :password, confirmation: true, presence: true,
            length: { minimum: 3 }
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true, presence: true
  validates :locale, presence: true
  validate :locale_as_available

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end

  def set_current_block(block)
    update_attribute(:current_block_id, block.id)
  end

  def reset_current_block
    update_attribute(:current_block_id, nil)
  end

  private

  def locale_as_available
    unless I18n.available_locales.include?(locale.to_sym)
      errors.add(:locale, 'Выберите локаль из выпадающего списка.')
    end
  end

  def set_locale_as_default
    self.locale = I18n.locale
  end
end
