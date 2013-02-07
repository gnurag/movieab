module Wikipedia
  module Abstract
    
    class Sublink
      include ROXML
      xml_name "sublink"
      xml_attribute :linktype
      xml_text :anchor
      xml_text :link
    end
    
    class Link
      include ROXML
      xml_name "links"
      xml_object :sublink, Sublink, ROXML::TAG_ARRAY
    end
    
    # All the wiki articles are enveloped inside <doc></doc>
    # tags. While parsing, one doc element will be passed.
    class Doc
      include ROXML
      xml_name "doc"
      xml_text :title
      xml_text :url
      xml_text :abstract
      xml_object :links, Link
    end
  end
end
