module Netflix
  # Pure Ruby XML parser class for miscllaneous netflix resources.
  module Response
    ##### ROXML class for Title Synopsis
    class TitleSynopsis
      include ROXML
      xml_name   "title_synopsis"
      xml_text   :synopsis
    end
    ##### END ROXML class for Title Synopsis.
    
    
    ##### ROXML class for Title Cast/Director
    class Link
      include ROXML
      xml_name "link"
      xml_attribute :rel
      xml_attribute :href
      xml_attribute :title
    end

    class Person
      include ROXML
      xml_name "person"
      xml_text :id
      xml_text :name
      xml_text :bio
      xml_object :link, Link, ROXML::TAG_ARRAY
    end

    class TitlePerson
      include ROXML
      xml_name   "people"
      xml_object :person, Person, ROXML::TAG_ARRAY
    end
    ##### END ROXML class for Title Cast/Director.


    ##### ROXML class for Title Awards and Nominations
    class Category
      include ROXML
      xml_name "category"
      xml_attribute :scheme
      xml_attribute :label
      xml_attribute :term
    end

    class AwardWinner
      include ROXML
      xml_name "award_winner"
      xml_attribute :year
      xml_object :winning_category, Category
      xml_object :winner, Link
    end

    class AwardNominee
      include ROXML
      xml_name "award_nominee"
      xml_attribute :year
      xml_object :nomination_category, Category
      xml_object :nominee, Link
    end

    class Awards
      include ROXML
      xml_name   "awards"
      xml_object :award_winner, AwardWinner, ROXML::TAG_ARRAY
      xml_object :award_nominee, AwardNominee, ROXML::TAG_ARRAY
    end
    ##### END ROXML class for Title Awards and Nominations
  end
end
