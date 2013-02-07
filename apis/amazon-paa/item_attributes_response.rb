module AmazonPAA
  module Response

    class ItemAttributes
      include ROXML
      xml_name "ItemAttributes"
      # xml_object :actors # Omitted. Add later if needed.
      xml_text :aspect_ratio, "AspectRatio"
      xml_text :audience_rating , "AudienceRating"
      xml_text :binding , "Binding"
      # xml_object :creator # Omitted. Add later if needed.
      # xml_object :director # Omitted. Add later if needed.
      xml_text :dvd_layers , "DVDLayers"
      xml_text :dvd_sides , "DVDSides"
      xml_text :ean , "EAN"
      # xml_object :format # Omitted. Add later if needed.
      xml_text :isbn , "ISBN"
      xml_text :label , "Label"
      # xml_object :languages # Omitted. Add later if needed.
      # xml_object :list_prices # Omitted. Add later if needed.
      xml_text :manufacturer , "Manufacturer"
      xml_text :number_of_items , "NumberOfItems"
      xml_text :original_release_date , "OriginalReleaseDate"
      # xml_object :package_dimensions # Omitted. Add later if needed.
      xml_text :picture_format , "PictureFormat"
      xml_text :product_group , "ProductGroup"
      xml_text :product_type_name , "ProductTypeName"
      xml_text :publisher , "Publisher"
      xml_text :region_code , "RegionCode"
      xml_text :release_date , "ReleaseDate"
      xml_text :running_time , "RunningTime"
      xml_text :studio , "Studio"
      xml_text :theatrical_release_date , "TheatricalReleaseDate"
      xml_text :title , "Title"
      xml_text :upc , "UPC"
    end
  end
end
