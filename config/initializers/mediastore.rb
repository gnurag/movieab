module MediaStore
  mediastore_config  = YAML::load(File.open("#{Rails.root}/config/mediastore.yml"))
  STORAGE_PATH = mediastore_config[Rails.env]['storage_path']
  HOST = mediastore_config[Rails.env]['host']
end
