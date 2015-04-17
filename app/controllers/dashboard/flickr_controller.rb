require 'flickraw'

class Dashboard::FlickrController < Dashboard::BaseController
  respond_to :js

  def get_flickr_images
    FlickRaw.api_key = ENV['FLICKR_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_SECRET']

    @flickr_images = flickr.photos.search(
        extras: 'url_sq, url_m', per_page: 10, page: 1, license: '1, 2, 3, 4, 5, 6, 7',
        text: params[:search])
  end
end
