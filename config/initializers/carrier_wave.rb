if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'  #=> 追加
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => ENV['S3_REGION'],     # 例: 'ap-northeast-1'
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
    # キャッシュの保存期間
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  end
  # 日本語ファイル名の設定
  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/ 
end


# if Rails.env.production?
#   CarrierWave.configure do |config|
#     config.storage :fog #=> 追加
#     config.fog_provider = 'fog/aws'  #=> 追加
#     config.fog_credentials = {
#       # Amazon S3用の設定
#       :provider              => 'AWS',
#       :region                => ENV['S3_REGION'],     # 例: 'ap-northeast-1'
#       :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
#       :aws_secret_access_key => ENV['S3_SECRET_KEY']
#     }
#     config.fog_directory     =  ENV['S3_BUCKET']
#     # キャッシュの保存期間
#     config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
#   end
#   # 日本語ファイル名の設定
#   CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/ 
# end