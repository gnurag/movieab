module AmazonPAA
  module Response

    class EditorialReview
      include ROXML
      xml_name "EditorialReview"
      xml_text :source, "Source"
      xml_text :content, "Content"
      xml_text :is_link_supressed, "IsLinkSuppressed"
    end
  end
end
