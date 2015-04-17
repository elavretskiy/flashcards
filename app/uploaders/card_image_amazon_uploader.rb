class CardImageAmazonUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  process resize_to_fit: [360, 360]
  process convert: 'jpg'

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename
      filename = original_filename.downcase + Time.now.to_s
      @name ||= Digest::MD5.hexdigest(filename).first(5)
      "#{@name}.#{file.extension.downcase}"
    end
  end
end
