if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
    :provider               => 'AWS',                                       # required
    :aws_access_key_id      => Render.config.aws_access_key_id,         # required
    :aws_secret_access_key  => Render.config.aws_secret_access_key,     # required
    #:region                 => 'eu-west-1',                                # optional, defaults to 'us-east-1'
    #:host                   => 's3.example.com',                           # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080'               # optional, defaults to nil
  }
  config.fog_directory  = Render.config.fog_directory                   # required
  #config.fog_public     = false                                            # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end
