module Netflix
  # Pure Ruby Capsulation for XML response recieved from NetflixCatalog call
  module CatalogResponse
    class Category
      include ROXML 
      xml_attribute :scheme
      xml_attribute :label
      xml_attribute :term
      xml_attribute :status
    end

    class Link
      include ROXML
      xml_attribute :rel
      xml_attribute :href
      xml_attribute :title
    end
    
    class Id
      include ROXML
      xml_name "id"
      xml_attribute :rel
      xml_text :text, nil, ROXML::TEXT_CONTENT
    end

    class ExternalIds
      include ROXML
      xml_name "external_ids"
      xml_object :id, Id, ROXML::TAG_ARRAY
    end

    class Availability
      include ROXML
      xml_name "availability"
      xml_attribute :available_from
      xml_object :categories, Category, ROXML::TAG_ARRAY
    end

    class DeliveryFormats
      include ROXML
      xml_name "delivery_formats"
      xml_object :availability, Availability, ROXML::TAG_ARRAY
    end

    class TitleIndexItem
      include ROXML
      xml_name "title_index_item"
      xml_text :title
      xml_text :id
      xml_object :categories, Category, ROXML::TAG_ARRAY
      xml_object :links, Link, ROXML::TAG_ARRAY 
      xml_text :release_year
      xml_object :external_ids, ExternalIds
      xml_object :delivery_formats, DeliveryFormats
      xml_text :updated
    end
  end
end
