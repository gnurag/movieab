require 'rubygems'
require 'yaml'
require 'ftools'
require 'oauth/consumer'
require 'oauth/signature/hmac/sha1' 
require 'roxml'

require "#{File.dirname(__FILE__)}/netflix_catalog_response.rb"
require "#{File.dirname(__FILE__)}/netflix_response.rb"
require "#{File.dirname(__FILE__)}/netflix_data.rb"
require "#{File.dirname(__FILE__)}/netflix_title_response.rb"

module Netflix
  protected
  NETFLIX_CONFIG = YAML::load(File.open(Rails.root.to_s + "/config/netflix.yml"))
  NETFLIX_KEY    = NETFLIX_CONFIG[Rails.env]["api_key"]
  NETFLIX_SECRET = NETFLIX_CONFIG[Rails.env]["api_secret"]
  NETFLIX_API_ROOT = NETFLIX_CONFIG[Rails.env]["api_root"]
  CONSUMER = OAuth::Consumer.new(NETFLIX_KEY, NETFLIX_SECRET, {:site => NETFLIX_API_ROOT})
  
  # Miscllaneous configs
  LOG_DIR  = "#{Rails.root.to_s}/log"
  
  # A generic module function to query Netflix's REST API for a given resource.
  def rest_query(resource)
    ## Ugly hack. This should be in a queue polled by a timer.
    sleep 1.05 
    response = Netflix::CONSUMER.request(:get, "/#{resource}", nil, {:scheme => :query_string})
    logWebservice("netflix", resource, response.body) if response.code != "200"
    return response
  end
  module_function :rest_query

  def logWebservice(service, resource, response="*SUPRESSED*")
    yyyymmdd = Date.today.strftime("%Y-%m-%d")
    log_dir  = "#{Netflix::LOG_DIR}/netflix/#{yyyymmdd}/"
    if File.exists?(Netflix::LOG_DIR) and File.writable?(Netflix::LOG_DIR)
      File.makedirs(log_dir) if not File.exists?(log_dir)
      log_file = "#{log_dir}/#{service}_#{Time.now.strftime('%Hh.%Mm.%Ss')}_#{rand(100000)}"
      f        = File.open(log_file, File::WRONLY | File::APPEND | File::CREAT)
      logger   = Logger.new(f)
      logger.info(service) {"REQUEST:\n#{resource}\n----\nRESPONSE:\n#{response}"}
      logger.close
    end
  end
  module_function :logWebservice

  class Movie
    def self.title(nf_title_id, title_type='movies')
      title = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}?expand=synopsis,awards")
      if title and title.code == "200"
        File.open(Rails.root.to_s+"/tmp/latest.xml", "w") {|f| f.write(title.body)}
        return Netflix::TitleResponse::CatalogTitle.parse(title.body)
      end
    end

    def self.title_synopsis(nf_title_id, title_type='movies')
      synopsis = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/synopsis")
      if synopsis and synopsis.code == "200"
        # Ugly hack. The XML response doesnt have a parent tag for automagic ROXML parsing
        # So, we enclose it in <title_synopsis> tags instead.
        return Netflix::Response::TitleSynopsis.parse("<title_synopsis>#{synopsis.body}</title_synopsis>")
      end
    end

    def self.title_awards(nf_title_id, title_type='movies')
      awards = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/awards")
      if awards and awards.code == "200"
        return Netflix::Response::Awards.parse(awards.body)
      end
    end

    def self.title_cast(nf_title_id, title_type='movies')
      cast = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/cast")
      if cast and cast.code == "200"
        return Netflix::Response::TitlePerson.parse(cast.body)
      end
    end

    def self.title_directors(nf_title_id, title_type='movies')
      directors = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/directors")
      if directors and directors.code == "200"
        return Netflix::Response::TitlePerson.parse(directors.body)
      end
    end

    def self.title_format_availability(nf_title_id, title_type='movies')
      formats = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/format_availability")
    end

    def self.title_screen_formats(nf_title_id, title_type='movies')
      screens = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/screen_formats")
    end

    def self.title_languages_and_audio(nf_title_id, title_type='movies')
      languages = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/languages_and_audio")
    end

    def self.title_similars(nf_title_id, title_type='movies')
      similars = Netflix::rest_query("/catalog/titles/#{title_type}/#{nf_title_id}/similars")
    end


    # Debugging/Heavyweight functions
    def self.nf(url)
      nf_data = Netflix::CONSUMER.request(:get, url, nil, {:scheme => :query_string})
      Netflix::logWebservice("nf_data", url, nf_data.body)
      File.open(Rails.root.to_s+"/tmp/latest.xml", "w") {|f| f.write(nf_data.body)}
      return nf_data.body
    end

    def self.nf_signed_url(url)
      spath = Netflix::CONSUMER.create_signed_request(:get, url, nil, {:scheme => :query_string}).path
      return "#{Netflix::NETFLIX_API_ROOT}#{spath}"
    end

    def self.nfindex_small
      movie = Netflix::CONSUMER.request(:get, "/catalog/index", nil, {:scheme => :query_string})
      File.open(Rails.root.to_s+"/tmp/index.xml", "w") {|f| f.write(movie.body)} if movie.code == "200"
    end
    def self.nfindex_old
      movie = Netflix::CONSUMER.request(:get, "/catalog/titles/index", nil, {:scheme => :query_string})
      File.open(Rails.root.to_s+"/tmp/index.xml", "w") {|f| f.write(movie.body)} if movie.code == "200"
    end

    def self.nfindex
      url = Netflix::Movie.nf_signed_url '/catalog/titles/index'
      `wget '#{url}' -O #{Rails.root.to_s}/tmp/index.xml`
    end
  end
end
