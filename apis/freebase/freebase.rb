require 'rubygems'
require 'yaml'
require 'ftools'

module FreebaseData
  protected
  FREEBASE_CONFIG = YAML::load(File.open(Rails.root.to_s + "/config/freebase.yml"))
  FREEBASE_ROOT   = FREEBASE_CONFIG[Rails.env]["freebase_root"]

  require "#{File.dirname(__FILE__)}/freebase_film.rb"

  # Miscllaneous configs
  LOG_DIR  = "#{Rails.root.to_s}/log"
end
