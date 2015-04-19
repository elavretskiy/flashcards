class FlickrService
  class << self
    def search_photos(text, license, extras, per_page, page)
      FlickRaw.api_key = ENV['FLICKR_KEY']
      FlickRaw.shared_secret = ENV['FLICKR_SECRET']

      flickr.photos.search(
        extras: extras, per_page: per_page, page: page, license: license, text: text)
    end
  end
end
