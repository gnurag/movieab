class AmazonItem < ActiveRecord::Base
  belongs_to :title

  def self.populate(title)
    upc = title.title_upc
    if upc and upc.length > 0
      begin
        amz = AmazonPAA::ItemSearch.query(upc[0].upc)
        # Check if ItemSearch returned a valid response
        if amz and amz.items.request.is_valid == "True"
          if amz.items.total_results.to_i > 0
            amz.items.item.each{|axitem|
              # Populating ItemAttributes
              # axitem -> ROXML Item object
              # ai     -> ActiveRecord Item object
              ai = AmazonItem.find_by_asin(axitem.asin) || AmazonItem.new
              ai_attrib = axitem.item_attributes # Just so that object's attribute lookups don't eat up tiny CPU resources ;-)
              
              ai.title_id         = title.id
              ai.asin             = axitem.asin
              ai.ean              = ai_attrib.ean
              ai.isbn             = ai_attrib.isbn
              ai.upc              = ai_attrib.upc
              ai.detail_page      = axitem.detail_page_url
              ai.sales_rank       = axitem.sales_rank
              ai.aspect_ratio     = ai_attrib.aspect_ratio
              ai.audience_rating  = ai_attrib.audience_rating
              ai.binding          = ai_attrib.binding
              ai.dvd_layers       = ai_attrib.dvd_layers
              ai.dvd_sides        = ai_attrib.dvd_sides
              ai.label            = ai_attrib.label
              ai.manufacturer     = ai_attrib.manufacturer
              ai.orig_release     = ai_attrib.original_release_date
              ai.release_date     = ai_attrib.release_date
              ai.theatre_release  = ai_attrib.theatrical_release_date
              ai.picture_format   = ai_attrib.picture_format
              ai.publisher        = ai_attrib.publisher
              ai.region_code      = ai_attrib.region_code
              ai.running_time     = ai_attrib.running_time
              ai.studio           = ai_attrib.studio
              ai.title_name       = ai_attrib.title
              
              ai.save

              ## Populating AmazonImages from Item's ImageSets attribute
              aimg = AmazonImage.find_by_title_id(title.id) || AmazonImage.new
              if axitem.image_sets and axitem.image_sets.length > 0
                aximages = axitem.image_sets.first

                aimg.title_id         = title.id
                aimg.swatch           = aximages.swatch_image.url
                aimg.swatch_height    = aximages.swatch_image.height
                aimg.swatch_width     = aximages.swatch_image.width
                aimg.small            = aximages.small_image.url
                aimg.small_height     = aximages.small_image.height
                aimg.small_width      = aximages.small_image.width
                aimg.thumbnail        = aximages.thumbnail_image.url
                aimg.thumbnail_height = aximages.thumbnail_image.height
                aimg.thumbnail_width  = aximages.thumbnail_image.width
                aimg.tiny             = aximages.tiny_image.url
                aimg.tiny_height      = aximages.tiny_image.height
                aimg.tiny_width       = aximages.tiny_image.width
                aimg.medium           = aximages.medium_image.url
                aimg.medium_height    = aximages.medium_image.height
                aimg.medium_width     = aximages.medium_image.width
                aimg.large            = aximages.large_image.url
                aimg.large_height     = aximages.large_image.height
                aimg.large_width      = aximages.large_image.width
                
                aimg.save
              end

              # Populating Amazon Editorial Reviews from Item's EditorialReviews attribute
              if axitem.editorial_reviews and axitem.editorial_reviews.length > 0
                axitem.editorial_reviews.each{|axer|
                  ## TODO: Warning! This section doesn't save multiple editorial reviews, instead finds same reviews again
                  aereview = AmazonEditorialReview.find_by_title_id(title.id) || AmazonEditorialReview.new
                  aereview.title_id = title.id
                  aereview.source   = axer.source
                  aereview.content  = axer.content
                  aereview.supressed = axer.is_link_supressed
                  
                  aereview.save
                }
              end
            }
          end
        end
      rescue Exception => e
        Rails.logger.error("AmazonPAA::ItemSearch query failed: #{upc[0].upc} : #{e.to_s}")
      end
    end
  end
  
end
