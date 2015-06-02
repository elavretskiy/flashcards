require 'nokogiri'
require 'open-uri'

class Dashboard::CardsController < Dashboard::BaseController
  before_action :set_card, only: [:destroy, :edit, :update]
  respond_to :html

  def index
    @cards = current_user.cards.all.order('review_date')
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def destroy
    @card.destroy
    respond_with @card
  end

  def get_flickr_images
    @flickr_images = FlickrService.search_photos(
      # A free text search. Photos who's title, description or tags contain the
      # text will be returned. You can exclude results that match a term by
      # prepending it with a - character.
      params[:search],

      # The license id for photos (for possible values see the
      # flickr.photos.licenses.getInfo method). Multiple licenses may be
      # comma-separated.
      '1, 2, 3, 4, 5, 6, 7',

      # A comma-delimited list of extra information to fetch for each returned
      # record. Currently supported fields are: description, license,
      # date_upload, date_taken, owner_name, icon_server, original_format,
      # last_update, geo, tags, machine_tags, o_dims, views, media, path_alias,
      # url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o
      'url_sq, url_m',

      # Number of photos to return per page. If this argument is omitted,
      # it defaults to 100. The maximum allowed value is 500.
      10,

      # The page of results to return. If this argument is omitted,
      # it defaults to 1.
      1
    )
  end

  def parsing_html
    parse = CardsService.parsed_html?(current_user.id,
                                      parsing_html_params[:block_id],
                                      parsing_html_params[:url],
                                      parsing_html_params[:css_original],
                                      parsing_html_params[:css_translated])

    if parse
      flash.now[:notice] = 'Задача на парсинг сайта успешно поставлена в очередь.'
      flash.now[:alert] = nil
    else
      flash.now[:alert] = 'Проверьте правильность введенных данных.'
      flash.now[:notice] = nil
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date,
                                 :image, :image_cache, :remove_image, :block_id,
                                 :remote_image_url)
  end

  def parsing_html_params
    params.require(:parsing_html).permit(:block_id, :url, :css_original, :css_translated)
  end
end
