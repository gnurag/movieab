module Netflix
  # Pure Ruby Capsulation for XML recieved for each movie
  module TitleResponse
    class Title
      include ROXML
      xml_attribute :short
      xml_attribute :regular
    end
    class Link
      include ROXML
      xml_attribute :rel
      xml_attribute :href
      xml_attribute :title
      xml_text      :synopsis
      xml_object    :awards, Netflix::Response::Awards
    end
    class Category
      include ROXML 
      xml_attribute :scheme
      xml_attribute :term
    end
    
    class BoxArt
      include ROXML
      xml_name "box_art"
      xml_attribute :small
      xml_attribute :medium
      xml_attribute :large
    end

    class CatalogTitle
      include ROXML
      xml_name   "catalog_title"
      xml_text   :id
      xml_object :title, Title
      xml_object :box_art, BoxArt
      xml_object :link, Link
      xml_text   :release_year
      xml_object :categories, Category, ROXML::TAG_ARRAY
      xml_text   :runtime
      xml_object :link_info, Link, ROXML::TAG_ARRAY
      xml_text   :average_rating
    end
  end
end
