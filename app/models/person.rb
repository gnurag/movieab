class Person < ActiveRecord::Base
  has_many :title_casts
  has_many :titles, :through => :title_casts
  has_many :awards
  has_many :google_images, :foreign_key => "resource_id", :conditions => "google_images.resource_type = 'person'"
  has_many :reviews, :foreign_key => "resource_id", :conditions => "reviews.resource_type = 'person' AND reviews.published = 1 AND reviews.disabled = 0"

  cattr_reader :per_page
  @@per_page = 30

  def name_for_url
    url_name = self.name.gsub(/[^a-zA-Z0-9\- ]/, "").gsub(/\s+/, "-").downcase
    return "#{self.id}-#{url_name}"
  end
  def title_for_url
    return name_for_url
  end

  def profile_image_url
    random_cdn = rand(10)
    return "http://cdn-#{random_cdn}.nflximg.com/us/headshots/#{self.nfid}.jpg"
  end

  def refresh_data
    updated = false
    if not self.gi_synced and ((self.bio and self.bio != "") or (self.titles.length >= 5))
      self.gi_synced = true
      self.save

      GoogleImage.populate_images(self)
      updated = true
    end
    return updated
  end
end
