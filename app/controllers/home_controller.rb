class HomeController < ApplicationController
  respond_to :html

  def index
    @card = Card.pending.first
  end
end
