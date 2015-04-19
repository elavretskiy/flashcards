require 'rubygems'
require 'fog'

CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.cucumber?
    config.fog_credentials = {
      provider: 'AWS',
      use_iam_profile: true,
      region: ENV['S3_REGION']
    }
  else
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_KEY'],
      aws_secret_access_key: ENV['S3_SECRET'],
      region: ENV['S3_REGION']
    }
  end

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  # To let CarrierWave work on heroku
  config.cache_dir = "#{Rails.root}/public/uploads/tmp"

  config.fog_directory = ENV['S3_BUCKET_NAME']
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
end
