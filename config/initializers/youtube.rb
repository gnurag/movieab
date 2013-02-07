module MovieAB
  module Youtube
    youtube_config  = YAML::load(File.open("#{Rails.root}/config/youtube.yml"))
    API_KEY = youtube_config[Rails.env]['api_key']
  end
end
