module AmazonPAA
  class ItemSearch
    def self.query(keywords)
      resource = AmazonPAA::AMAZON_ENDPOINT # To start with.
      params = {
        "Service"        => "AWSECommerceService",
        "AWSAccessKeyId" => AmazonPAA::AMAZON_ACCESS_KEY_ID,
        "Operation"      => "ItemSearch",
        "SearchIndex"    => "DVD",
        "ResponseGroup"  => "EditorialReview,ItemAttributes,Large,Medium,Reviews",
        "Keywords"       => keywords,
        "Version"        => "2009-01-06",
        "AssociateTag"   => AmazonPAA::AMAZON_AFFILIATE_ID
      }
      resource += "?" + params.sort.collect{|key, value| [key, value].join("=")}.join("&")
      response_xml = AmazonPAA.rest_query(resource)

      #f = File.open("/tmp/amazon.xml", 'w')
      #f.write(response_xml)
      #f.close
      return AmazonPAA::Response::ItemSearchResponse.parse(response_xml)
    end
  end
end
