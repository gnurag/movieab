require 'rubygems'
require 'yaml'
require 'ftools'
require 'roxml'

require "#{File.dirname(__FILE__)}/nytimes_response.rb"

module NYTimes
  protected
  NYTIMES_CONFIG = YAML::load(File.open(Rails.root.to_s + "/config/nytimes.yml"))
  NYTIMES_KEY    = NYTIMES_CONFIG[Rails.env]["api_key"]
  NYTIMES_SECRET = NYTIMES_CONFIG[Rails.env]["api_secret"]
  NYTIMES_API_ROOT = NYTIMES_CONFIG[Rails.env]["api_root"]

  # Miscllaneous configs
  LOG_DIR  = "#{Rails.root.to_s}/log"

  # A generic module function to query NYTimes's REST API for a given resource.
  def rest_query(resource)
    ## Ugly hack. This should be in a queue polled by a timer.
    sleep 1.05
    resource += "&api-key=#{NYTIMES_KEY}"
    url      = URI.parse(resource)
    request  = Net::HTTP::Get.new(resource)
    response = Net::HTTP.start(url.host, url.port) {|http|
      http.request(request)
    }
    logWebservice("search", resource, response.body) if response.code != "200"
    return response
  end
  module_function :rest_query
  
  def logWebservice(service, resource, response="*SUPRESSED*")
    yyyymmdd = Date.today.strftime("%Y-%m-%d")
    log_dir  = "#{NYTimes::LOG_DIR}/nytimes/#{yyyymmdd}/"
    if File.exists?(NYTimes::LOG_DIR) and File.writable?(NYTimes::LOG_DIR)
      File.makedirs(log_dir) if not File.exists?(log_dir)
      log_file = "#{log_dir}/#{service}_#{Time.now.strftime('%Hh.%Mm.%Ss')}_#{rand(100000)}"
      f        = File.open(log_file, File::WRONLY | File::APPEND | File::CREAT)
      logger   = Logger.new(f)
      logger.info(service) {"REQUEST:\n#{resource}\n----\nRESPONSE:\n#{response}"}
      logger.close
    end
  end
  module_function :logWebservice
  
  class Review
    def self.search(title)
      title_escaped = CGI.escape(title.downcase)
      review = NYTimes.rest_query("#{NYTIMES_API_ROOT}/reviews/search.xml?query=#{title_escaped}")
      if review and review.code == "200"
        return NYTimes::Response::ResultSet.parse(review.body)
      end
    end
  end

end
