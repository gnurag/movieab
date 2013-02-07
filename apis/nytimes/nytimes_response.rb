module NYTimes
  # Pure Ruby XML parser class for NYTimes review searches
  module Response
    
    class Link
      include ROXML
      xml_name "link"
      xml_attribute :type
      xml_text :url
      xml_text :suggested_link_text
    end
    
    class RelatedURLs
      include ROXML
      xml_name "related_urls"
      xml_object :links, Link, ROXML::TAG_ARRAY
    end

    class Review
      include ROXML
      xml_name "review"
      xml_attribute :nyt_movie_id
      xml_text :display_title
      xml_text :sort_name
      xml_text :mpaa_rating
      xml_text :critics_pick
      xml_text :thousand_best
      xml_text :byline
      xml_text :headline
      xml_text :capsule_review
      xml_text :summary_short
      xml_text :publication_date
      xml_text :opening_date
      xml_text :dvd_release_date
      xml_text :date_updated
      xml_text :seo_name, "seo-name"
      xml_object :link, Link, ROXML::TAG_ARRAY #todo
      xml_object :related_urls, RelatedURLs, ROXML::TAG_ARRAY #todo
    end
    
    class Results
      include ROXML
      xml_name "results"
      xml_object :review, Review, ROXML::TAG_ARRAY
    end
    
    class ResultSet
      include ROXML
      xml_name "result_set"
      xml_text :status
      xml_text :copyright
      xml_text :num_results
      xml_object :results, Results
    end
  end
end
