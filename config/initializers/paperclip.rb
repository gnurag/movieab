## Btw, there's a module named Paperclip loaded as well.
module Paperclip
  paperclip_config  = YAML::load(File.open("#{Rails.root}/config/paperclip.yml"))
  STORAGE_PATH = paperclip_config[Rails.env]['storage_path']
  HOST = paperclip_config[Rails.env]['host']
end
