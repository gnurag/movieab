class Title < ActiveRecord::Base
  has_many :title_casts
  has_many :title_generes
  has_one  :nytimes_review
  has_many :award_nominations, :order => "award_type DESC, award_id"
  has_many :actors, :through => :title_casts,  :source => :person, :conditions => "people.role = 'actor'"
  has_many :directors, :through => :title_casts,  :source => :person, :conditions => "people.role = 'director'"
  has_many :generes, :through => :title_generes, :source => :genere, :conditions => "generes.genere_type = 'genere' or generes.genere_type = '' or generes.genere_type IS NULL"
  has_many :studios, :through => :title_generes, :source => :genere, :conditions => "generes.genere_type = 'studio'"
  has_many :generes_media, :through => :title_generes, :source => :genere, :conditions => "generes.genere_type = 'disc'"
  has_many :google_images, :foreign_key => "resource_id", :conditions => "google_images.resource_type = 'title'"
  has_many :youtube_videos
  has_many :reviews, :conditions => "reviews.published = 1 AND reviews.disabled = 0"
  has_many :title_upc
  has_many :amazon_items
  has_many :amazon_images
  has_many :amazon_editorial_reviews

  acts_as_xapian :texts => [:title, :synopsis], 
                 :values => [[:release_year, 0, "release_year", :number],
                             [:created_at  , 1, "created_at"  , :date]],
                 :terms => [[:release_year, "Y", "year"],
                            [:mpaa_rating, "R", "rating"]]
  
  cattr_reader :per_page
  @@per_page = 30


  ## Function for searching title catalog using Xapian search engine.
  def self.xapian_search(query, limit=50)
    titles = []
    metadata = {}
    matches = ActsAsXapian::Search.new([Title], query, {:limit => limit})
    if matches and matches.results and matches.results.length > 0
      matches.results.each{|r|
        titles.push(r[:model])
      }
    end
    metadata[:spelling_correction] = matches.spelling_correction
    return [titles, metadata]
  end

  
  ####
  ## ** Functions for managing title's media **
  ## 
  ## Function to download boxart image from Netflix CDN to local filesystem.
  def cache_images(options = {})
    opts = {
      :overwrite => false, 
      :sleep => 0,
      :small => false,
      :medium => false,
      :large => true,
      :hd => true
    }.merge(options)
    sleep_flag = false

    if File.exists?(MediaStore::STORAGE_PATH) and File.writable?(MediaStore::STORAGE_PATH)
      image_dir = "#{MediaStore::STORAGE_PATH}/titles/#{dirhash}"
      notfound_file = "#{MediaStore::STORAGE_PATH}/404"

      formats = {}
      formats["small"]  = self.box_art_small  if opts[:small]  and not self.box_art_small.nil?
      formats["medium"] = self.box_art_medium if opts[:medium] and not self.box_art_medium.nil?
      formats["large"]  = self.box_art_large  if opts[:large]  and not self.box_art_large.nil?
      formats["hd"]     = self.box_art_hd     if opts[:hd]     and not self.box_art_hd.nil?

      formats.each{|size, img|
        image_dest    = get_image_path( :size => size )
        notfound_dest = get_image_path( :size => size, :extension => '404' )
        if img and (opts[:overwrite] or not File.exists?(image_dest)) and not File.exists?(notfound_dest)
          ## Download the image only if (overwrite is true -OR- if the image hasn't been downloaded already)
          #  AND (404 flag file does not exist.)

          puts "#{img}  ==>  #{image_dest}"
          url = URI.parse(img)
          begin
            Net::HTTP.start(url.host){|http|
              resp = http.get(url.path)
              puts "CDN response code: #{resp.code}"
              File.makedirs(image_dir) if not File.exists?(image_dir)
              if resp.code == "200"
                File.delete(image_dest) if File.exists?(image_dest)
                open(image_dest, "wb") {|file| file.write(resp.body) }
              elsif resp.code == "404"
                # Cannot use link technique in ext3 filesystem to to its limitation of 
                # 32K max links to a file. Enable this later if this is running on a 
                # better filesystem. This is purely space saving measure.
                #
                # File.link(notfound_file, notfound_dest)
                FileUtils.touch(notfound_dest)
              end
            }
          rescue Exception => e
            puts "Exception: #{e}"
            Rails.logger.error "Error downloading image: #{e}"
          end
          sleep_flag = true ## If we entered this loop to fire http call to CDN, we must sleep.
        end
      }
      
      ## Sleep for some time to avoid triggering off CDN's alarms.
      sleep opts[:sleep] if sleep_flag
    else
      Rails.logger.error "Media storage path: #{MediaStore::STORAGE_PATH} unwritable."
    end
  end
  
  def get_image_path(options = {})
    opts = {:size => "large", :extension =>  "jpg"}.merge(options)
    return "#{MediaStore::STORAGE_PATH}/titles/#{dirhash}/#{self.id}.#{opts[:size]}.#{opts[:extension]}"
  end

  ## Returns the web accessible location of the image.
  #  This function returns the url of image only if it exists on the local filesystem.
  def get_image_url(options = {})
    opts = {:size => "large"}.merge(options)
    if File.exists?( self.get_image_path(options) )
      return "http://#{MediaStore::HOST}/titles/#{dirhash}/#{self.id}.#{opts[:size]}.jpg"
    else
      return nil
    end
  end
  
  # Convert the title's id to a directory hash with 2 char delimitation.
  # Thanks @brainfunked - http://twitter.com/brainfunked/status/45472375667568640
  def dirhash
    return self.id.to_s.gsub(/(.{2})(.{2}$)?/,'\1/\2')
  end


  ## Only used for bulk importing/refreshing data from netflix catalog index.
  def self.add_update_title(title_catalog)
    nfid = title_catalog.id.split("/")[6]
    t = Title.find_by_nfid(nfid) || Title.new
    
    # ^^  Temp hack. replace this with below line when netflix_id is in new format.
    #    t = Title.find_by_netflix_id(title_catalog.id) || Title.new

    t.title = title_catalog.title
    t.supplier_id = 1
    t.netflix_id  = title_catalog.id
    
    title_catalog_array = title_catalog.id.split("/")
    if title_catalog_array.length >= 7
      t.nfid = title_catalog_array[6]
      t.title_type = title_catalog_array[5]
    end

    t.nf_updated = title_catalog.updated.to_i if title_catalog.updated
    t.release_year = title_catalog.release_year.to_i
    #t.website_url = title_catalog.nflx_entities.website_url
    t.disabled   = false if t.new_record?
    
    if t.save
      ## Filter out deprecated categories and add them.
      if title_catalog.categories and title_catalog.categories.length > 0
        handle_catalog_categories(title_catalog.categories, t)
      end
      if title_catalog.links and title_catalog.links.length > 0
        handle_catalog_links(title_catalog.links, t)
      end

      ## Add the UPC code for this DVD in a separate table.
      if title_catalog.external_ids and title_catalog.external_ids.id and title_catalog.external_ids.id.length > 0
        title_catalog.external_ids.id.each{|id|
          TitleUpc.find_or_create_by_title_id_and_upc(:title_id => t.id, :upc => id.text)
        }
      end
    end
  end
  
  ## Queries netflix rest api and fills up slots of title.
  def populate_from_netflix
    nfid       = self.nfid
    title_type = self.title_type.pluralize
    
    title = Netflix::Movie.title(nfid, title_type)
    if title
      self.title_short    = title.title.short
      self.runtime        = title.runtime
      self.netflix_rating = title.average_rating
      self.box_art_small  = title.box_art.small
      self.box_art_medium = title.box_art.medium
      self.box_art_large  = title.box_art.large

      ## Fetch synopsis from expanded results
      synopsis = get_synopsis_object(title)
      if synopsis
        self.synopsis = synopsis
      end
    
      ## title object still has cast, directors data. call these pvt. functions 
      # to fetch more data from wsapi and save them in db.
      cast = Netflix::Movie.title_cast(nfid, title_type)
      handle_title_link_info(cast, "actor", self.id)
      
      directors = Netflix::Movie.title_directors(nfid, title_type)
      handle_title_link_info(directors, "director", self.id)
      
      ## Fetch awards object from expanded results
      awards = get_awards_object(title)
      if awards
        handle_title_awards(awards.award_nominee, 'nomination', self.id) if awards.award_nominee
        handle_title_awards(awards.award_winner, 'winner', self.id) if awards.award_winner
      end
      
      ## Loops over categories array and fills mpaa ratings, and generes table
      handle_title_categories(title.categories) if title.categories
      
      return self
    end
  end

  ## Function for retrieving NYTimes reviews using nytimes movie review apis
  def populate_from_nytimes
    review = NYTimes::Review.search(self.title)
    if review and review.status == "OK"
      review.results.review.each{|movie|
        save_nytimes_review(movie)
      }
    end
  end

  def title_for_url
    url_title = self.title.gsub(/[^a-zA-Z0-9 ]/, "").gsub(/\s+/, "-").downcase
    return "#{self.id}-#{url_title}"
  end
  alias :urlid :title_for_url

  def self.url_to_id(url_id)
    return url_id.split("-").first
  end

  ## Returns HD poster of a title.
  def box_art_hd
    return self.box_art_large.gsub("boxshots/large/", "boxshots/ghd/") if not self.box_art_large.nil?
  end


  ## Function to check for stale/non-existant data and refresh it from
  #  various data source apis.
  def refresh_title_data
    updated = false
    if not self.nf_synced
      self.populate_from_netflix
      self.cache_images
      self.nf_synced = true
      updated = true
    end
    if not self.nyt_synced
      self.populate_from_nytimes
      self.nyt_synced = true
      updated = true
    end
    if not self.gi_synced
      GoogleImage.populate_images(self)
      self.gi_synced = true
      updated = true
    end
    if not self.yt_synced
      YoutubeVideo.populate_videos(self)
      self.yt_synced = true
      updated = true
    end
    if not self.amzn_synced
      AmazonItem.populate(self)
      self.amzn_synced = true
      updated = true
    end

    self.save
    return updated
  end

  ## Function to reset synced status for netflix, nytimes, google_images and amazon
  def sync_reset
    self.nf_synced = false
    self.nyt_synced = false
    self.amzn_synced = false
    self.gi_synced = false
    self.yt_synced = false
    
    self.google_images.each{|gi| gi.destroy}
    self.youtube_videos.each{|yv| yv.destroy}
    self.save
  end
  
  
  ## Miscllaneous functions for handling title, review data from API's XML response

  private
  ## Iterates over <link> tag objects and saves cast,director information.
  # To keep things simple and dry, we use `cast' for actors and directors both.
  def handle_title_link_info(cast, person_type, title_id)
    if cast and cast.person.length > 0
      cast.person.each{|actor|
        ## Retrieving actor's alternate webpage.
        actor_links = {}
        actor.link.each{|l| actor_links[l.title] = l.href}
        
        ## Save actor in db if it doesnt exist.
        current_actor = Person.find_by_netflix_id(actor.id)
        if not current_actor
          current_actor = Person.new
          current_actor.netflix_id = actor.id
          current_actor.nfid  = actor.id.split("/").last.to_i
          current_actor.name  = actor.name
          current_actor.role  = person_type
          current_actor.bio  = actor.bio
          current_actor.website_url  = actor_links["web page"]
          current_actor.nf_synced  = true
          current_actor.save
        end
        
        ## Also mark an entry into title_casts interlinking table.
        if not TitleCast.exists?(:person_id => current_actor.id, :title_id  => title_id)
          TitleCast.create(:person_id => current_actor.id, :title_id  => title_id)
        end
      }
    end
  end

  ## Iterates over awards object containing winnings and nominations details.
  # While iterating over win/nomination objects, award type is created first,
  # and its primary key is saved onto the award into.
  def handle_title_awards(awards, type, title_id)
    awards.each{|award|
      if type == "nomination"
        category  = award.nomination_category
        nominee   = award.nominee.nil? ? nil : Person.find_by_netflix_id(award.nominee.href).id
      elsif type == "winner"
        category  = award.winning_category
        nominee   = award.winner.nil?  ? nil : Person.find_by_netflix_id(award.winner.href).id
      end
      award_id  = Award.find_or_create_by_scheme(category.scheme).id
      if not AwardNomination.exists?(:title_id => title_id, :award_id => award_id, :label => category.label)
        new_award = AwardNomination.new
        new_award.title_id = title_id
        new_award.award_id = award_id
        new_award.person_id = nominee
        new_award.year  = award.year
        new_award.label = category.label
        new_award.term  = category.term
        new_award.award_type = type
        new_award.save
      end
    }
  end

  def handle_title_categories(categories)
    categories.each{|category|
      if category
        if category.scheme == "http://api.netflix.com/categories/mpaa_ratings" or category.scheme == "http://api.netflix.com/categories/tv_ratings"
          self.mpaa_rating = category.term 
        else
          genere = Genere.find_or_create_by_name(:name => category.term)
          tg = TitleGenere.find_or_create_by_title_id_and_genere_id(:title_id => self.id, :genere_id => genere.id)
        end
      end
    }
  end

  ## Loops over link_info attributes of title response, and tries to find out 
  #  Synopsis object
  def get_synopsis_object(title)
    synopsis = nil
    if title and not title.link_info.nil?
      title.link_info.each{|link|
        if (not link.synopsis.nil?) and (link.synopsis.class == String) and (link.synopsis.length > 1)
          synopsis = link.synopsis
        end
      }
    end
    return synopsis
  end

  def get_awards_object(title)
    awards = nil
    if title and not title.link_info.nil?
      title.link_info.each{|link|
        awards = link.awards if (not link.awards.nil?)
      }
    end
    return awards
  end


  ## Private handlers for savings NYTimes reviews
  def parse_related_urls(rel)
    urlhash = {}
    if rel.length > 0
      rel[0].links.each{|r|
        urlhash[r.type.to_sym] = r.url
      }
    end
    return urlhash
  end

  def save_nytimes_review(movie)
    title = Title.find_by_title(movie.display_title)
    if title
      nyt_review = NytimesReview.find_by_title_id(title.id)
      if not nyt_review
        new_review = NytimesReview.new
        new_review.title_id      = title.id
        new_review.nyt_movie_id  = movie.nyt_movie_id
        new_review.display_title = movie.display_title
        new_review.sort_name     = movie.sort_name
        new_review.mpaa_rating   = movie.mpaa_rating
        new_review.critics_pick  = (movie.critics_pick == "Y") ? true : false
        new_review.thousand_best = (movie.thousand_best == "Y") ? true : false
        new_review.byline        = movie.byline
        new_review.headline      = movie.headline
        new_review.capsule_review= movie.capsule_review
        new_review.summary_short = movie.summary_short
        new_review.publication_date = movie.publication_date
        new_review.opening_date  = movie.opening_date
        new_review.dvd_release_date = movie.dvd_release_date
        new_review.date_updated  = movie.date_updated
        new_review.seo_name      = movie.seo_name
        new_review.article_url   = movie.link[0].url if (movie.link and movie.link[0] and movie.link[0].type == "article")

        related_urls = parse_related_urls(movie.related_urls)

        new_review.overview_url  = related_urls[:overview]
        new_review.showtimes_url = related_urls[:showtimes]
        new_review.awards_url    = related_urls[:awards]
        new_review.community_url = related_urls[:community]
        new_review.trailers_url  = related_urls[:trailers]
        new_review.thumbnail     = nil
        new_review.nyt_synced    = true
        new_review.save

        title.nyt_synced         = true
        title.save
        puts "added review for: " + movie.display_title
      end
    end
  end

  ### Handler functions for parsing arrays returned from catalog parse run.
  # These functions iterate over category and link tags and filter out 
  # tags that are marked as deprecated.
  
  def self.handle_catalog_categories(categories, title)
    categories.each{|category|
      if category.scheme == "http://api.netflix.com/categories/genres"
        genere = Genere.find_or_create_by_name(:name => category.term)
        tg = TitleGenere.find_or_create_by_title_id_and_genere_id(:title_id => title.id, :genere_id => genere.id)
      end
    }
  end

  def self.handle_catalog_links(links, title)
    links.each{|link|
      if link.rel == "http://schemas.netflix.com/catalog/person.actor"
        nfid = link.href.split('/')[5]; role = 'actor'
        p = Person.find_or_create_by_netflix_id(:netflix_id => link.href, :name => link.title,:role => role,:nfid => nfid)
        TitleCast.find_or_create_by_person_id_and_title_id(:person_id => p.id, :title_id  => title.id)
      elsif link.rel == "http://schemas.netflix.com/catalog/person.director"
        nfid = link.href.split('/')[5]; role = 'director'
        p = Person.find_or_create_by_netflix_id(:netflix_id => link.href, :name => link.title,:role => role,:nfid => nfid)
        TitleCast.find_or_create_by_person_id_and_title_id(:person_id => p.id, :title_id  => title.id)
      end
    }
  end
end
