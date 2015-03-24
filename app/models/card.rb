class Card < ActiveRecord::Base
  before_create :set_review

  def set_review
    self.review = Time.now + 3.days
  end
end
