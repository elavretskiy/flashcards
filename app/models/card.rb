class Card < ActiveRecord::Base
  before_save :set_review

  def set_review
    self.review = Time.now
  end
end
