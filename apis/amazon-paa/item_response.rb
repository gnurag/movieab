module AmazonPAA
  module Response

    class Item
      include ROXML
      xml_name "Item"
      xml_text :asin, "ASIN"
      xml_text :detail_page_url, "DetailPageURL"
      # xml_object :item_links # Omitted. Add later if needed.
      xml_text :sales_rank, "SalesRank"
      xml_object :small_image, SmallImage
      xml_object :medium_image, MediumImage
      xml_object :large_image, LargeImage
      xml_object :image_sets, ImageSet, ROXML::TAG_ARRAY, "ImageSets"
      xml_object :item_attributes, ItemAttributes
      xml_object :customer_reviews, CustomerReviews
      xml_object :editorial_reviews, EditorialReview, ROXML::TAG_ARRAY, "EditorialReviews"
    end


    class ItemSearchRequest
      include ROXML
      xml_name "ItemSearchRequest"
      xml_text :condition, "Condition"
      xml_text :delivery_method, "DeliveryMethod"
      xml_text :keywords, "Keywords"
      xml_text :merchant_id, "MerchantId"
      #xml_object :response_groups # Omitted. Add later if needed.
      xml_text :review_sort, "ReviewSort"
      xml_text :search_index, "SearchIndex"
    end

    class Request
      include ROXML
      xml_name "Request"
      xml_text :is_valid, "IsValid"
      xml_object :itemsearch_request, ItemSearchRequest
    end

    class Items
      include ROXML
      xml_name "Items"
      xml_object :request, Request
      xml_text :total_results, "TotalResults"
      xml_text :total_pages, "TotalPages"
      xml_object :item, Item, ROXML::TAG_ARRAY
    end
  end
end
