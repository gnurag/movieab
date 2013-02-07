module AmazonPAA
  module Response

    class SwatchImage
      include ROXML
      xml_name "SwatchImage"
      xml_text :url, "URL"
      xml_text :height, "Height"
      xml_text :width, "Width"
    end

    class SmallImage
      include ROXML
      xml_name "SmallImage"
      xml_text :url, "URL"
      xml_text :height, "Height"
      xml_text :width, "Width"
    end

    class ThumbnailImage
      include ROXML
      xml_name "ThumbnailImage"
      xml_text :url, "URL"
      xml_text :height, "Height"
      xml_text :width, "Width"
    end

    class TinyImage
      include ROXML
      xml_name "TinyImage"
      xml_text :url, "URL"
      xml_text :height, "Height"
      xml_text :width, "Width"
    end

    class MediumImage
      include ROXML
      xml_name "MediumImage"
      xml_text :url, "URL"
      xml_text :height, "Height"
      xml_text :width, "Width"
    end

    class LargeImage
      include ROXML
      xml_name "LargeImage"
      xml_text :url, "URL"
      xml_text :height, "Height"
      xml_text :width, "Width"
    end

    class ImageSet
      include ROXML
      xml_name "ImageSet"
      xml_object :swatch_image, SwatchImage
      xml_object :small_image, SmallImage
      xml_object :thumbnail_image, ThumbnailImage
      xml_object :tiny_image, TinyImage
      xml_object :medium_image, MediumImage
      xml_object :large_image, LargeImage
    end
  end
end
