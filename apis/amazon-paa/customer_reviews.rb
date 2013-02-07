module AmazonPAA
  module Response
    
    class Reviewer
      include ROXML
      xml_name "Reviewer"
      xml_text :customer_id, "CustomerId"
      xml_text :name, "Name"
      xml_text :location, "Location"
    end

    class Review
      include ROXML
      xml_name "Review"
      xml_text :asin, "ASIN"
      xml_text :rating, "Rating"
      xml_text :helpful_votes, "HelpfulVotes"
      xml_text :customer_id, "CustomerId"
      xml_object :reviewer, Reviewer
      xml_text :total_votes, "TotalVotes"
      xml_text :date, "Date"
      xml_text :summary, "Summary"
      xml_text :content, "Content"
    end

    class CustomerReviews
      include ROXML
      xml_name "CustomerReviews"
      xml_text :average_rating, "AverageRating"
      xml_text :total_reviews, "TotalReviews"
      xml_text :total_review_pages, "TotalReviewPages"
      xml_object :review, Review, ROXML::TAG_ARRAY
    end
  end
end
