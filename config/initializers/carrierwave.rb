CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAJ6UVUMX6VW2RVO4Q',                        # required
    :aws_secret_access_key  => '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'   # required
  }
  config.fog_directory  = 'lurc-trees'                     # required
end
