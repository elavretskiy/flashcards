class User < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_block, class_name: 'Block'
  before_save :check_locale

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

  def set_current_block(block)
    update_attribute(:current_block_id, block.id)
  end

  def reset_current_block
    update_attribute(:current_block_id, nil)
  end

  private

  def check_locale
    if locale
      if !I18n.available_locales.map(&:to_s).include?(locale)
        locale.empty? ? self.locale = nil : self.locale = I18n.default_locale
      end
    end
  end
end
