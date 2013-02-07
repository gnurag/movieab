require 'yaml'
require 'ftools'
require 'roxml'

require "#{File.dirname(__FILE__)}/item_attributes_response.rb"
require "#{File.dirname(__FILE__)}/image_sets_response.rb"
require "#{File.dirname(__FILE__)}/customer_reviews.rb"
require "#{File.dirname(__FILE__)}/editorial_reviews.rb"
require "#{File.dirname(__FILE__)}/item_response.rb"
require "#{File.dirname(__FILE__)}/itemsearch_response.rb"
require "#{File.dirname(__FILE__)}/itemsearch.rb"

module AmazonPAA
  protected
  AMAZON_CONFIG        = YAML::load(File.open(Rails.root.to_s + "/config/amazon-paa.yml"))
  AMAZON_ACCESS_KEY_ID = AMAZON_CONFIG[Rails.env]["access_key_id"]
  AMAZON_SECRET_ACCESS_KEY = AMAZON_CONFIG[Rails.env]["secret_access_key"]
  AMAZON_AFFILIATE_ID  = AMAZON_CONFIG[Rails.env]["affiliate_id"]
  AMAZON_ENDPOINT      = AMAZON_CONFIG[Rails.env]["endpoint"]

  # Miscllaneous configs
  LOG_DIR  = "#{Rails.root.to_s}/log"


  ## Central module function to query Amazon's product advertising API
  # It takes a valid query URL and fires the query
  def rest_query(resource)
    sleep 1.05
    resource = AmazonPAA::sign_request(resource)
    url = URI.parse(resource)

    request = Net::HTTP::Get.new(resource)
    response = Net::HTTP.start(url.host, url.port) {|http|
      http.request(request)
    }
    logWebservice("ItemSearch", resource, response.body) if response.code != "200"
    return response.body
  end
  module_function :rest_query

  def logWebservice(service, resource, response="*SUPRESSED*")
    yyyymmdd = Date.today.strftime("%Y-%m-%d")
    log_dir  = "#{AmazonPAA::LOG_DIR}/amazon/#{yyyymmdd}/"
    if File.exists?(AmazonPAA::LOG_DIR) and File.writable?(AmazonPAA::LOG_DIR)
      File.makedirs(log_dir) if not File.exists?(log_dir)
      log_file = "#{log_dir}/#{service}_#{Time.now.strftime('%Hh.%Mm.%Ss')}_#{rand(100000)}"
      f        = File.open(log_file, File::WRONLY | File::APPEND | File::CREAT)
      logger   = Logger.new(f)
      logger.info(service) {"REQUEST:\n#{resource}\n----\nRESPONSE:\n#{response}"}
      logger.close
    end
  end
  module_function :logWebservice


  ## A function for signing the request string. 
  # See Amazon product advertising api developer guide v20090701. Page 74
  def sign_request(resource)
    # Step 1: Enter the timestamp
    resource += "&Timestamp=#{Time.now.gmtime.iso8601}"

    # Step 2: URLEncode comma, colon and semicolon in the request url.
    url = URI.parse(resource)
    params = url.query.gsub(",", "%2C").gsub(":", "%3A").gsub(";","%3B")

    # Step 3: Sort the paramsters in alphabetic order.
    params = params.split("&").sort.join("&")

    # Step 4: Create the string to be signed.
    sign_string = "GET\n#{url.host}\n#{url.path}\n#{params}"

    # Step 5: Sign the above string with HMAC-SHA256 and the secret access key
    hmac = HMAC::SHA256.new(AMAZON_SECRET_ACCESS_KEY)
    hmac.update(sign_string)
    signature = Base64.encode64(hmac.digest).chomp

    # Step 6: URLencode the signature string
    signature = CGI.escape(signature)

    # Step 7: Append the signature to the url
    params += "&Signature=#{signature}"
    qs = "#{url.scheme}://#{url.host}#{url.path}?#{params}"
    return qs
  end
  module_function :sign_request
end
