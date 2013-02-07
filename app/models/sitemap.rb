class Sitemap
  def initialize
  end
  def get_binding
    binding
  end

  def get_sitemap_erb(sitemap_template)
    return ERB.new(File.read("#{Rails.root.to_s}/app/views/layouts/#{sitemap_template}.html.erb"))
  end

  ## 
  # Miscllaneous functions for site management
  def write_sitemap(sitemap_xml, filename)
    if File.exists?(Rails.root.to_s+"/public") and File.writable?(Rails.root.to_s+"/public")
      sitemap_file = "#{Rails.root.to_s}/public/#{filename}"
      File.delete(sitemap_file) if File.exists?(sitemap_file)
      f = File.open(sitemap_file, File::WRONLY | File::CREAT)
      f.write(sitemap_xml)
      f.close
    end
  end

  def generate
    total_allowed = 50000
    @index_contents = {}

    # Aggregating Titles for generating sitemaps
    total_titles  = Title.count(:conditions => "disabled = 0")
    required_sitemaps = (total_titles / total_allowed) + (total_titles % total_allowed > 0 ? 1 : 0)
    required_sitemaps.times{|counter|
      @urls = Title.find(:all, 
                            :select => "id, title",
                            :conditions => "disabled = 0", 
                            :offset => counter * total_allowed, 
                            :limit  => total_allowed)
      @controller = "titles"
      sitemap_xml = get_sitemap_erb("sitemap").result(self.get_binding)
      @index_contents[@controller] = required_sitemaps

      # We have the markup for sitemap. Writing this into public directory.
      write_sitemap(sitemap_xml, "sitemap-#{@controller}-#{counter+1}.xml")
    }

    # Aggregating People for generating sitemaps
    total_people  = Person.count(:conditions => "disabled = 0")
    required_sitemaps = (total_people / total_allowed) + (total_people % total_allowed > 0 ? 1 : 0)
    required_sitemaps.times{|counter|
      @urls = Person.find(:all, 
                            :select => "id, name",
                            :conditions => "disabled = 0", 
                            :offset => counter * total_allowed, 
                            :limit  => total_allowed)
      @controller = "people"
      sitemap_xml = get_sitemap_erb("sitemap").result(self.get_binding)
      @index_contents[@controller] = required_sitemaps

      # We have the markup for sitemap. Writing this into public directory.
      write_sitemap(sitemap_xml, "sitemap-#{@controller}-#{counter+1}.xml")
    }

    # Aggregating Users for generating sitemaps
    total_users  = User.count
    required_sitemaps = (total_users / total_allowed) + (total_users % total_allowed > 0 ? 1 : 0)
    required_sitemaps.times{|counter|
      @urls = User.find(:all, 
                            :select => "id, fullname, email",
                            :offset => counter * total_allowed, 
                            :limit  => total_allowed)
      @controller = "users"
      sitemap_xml = get_sitemap_erb("sitemap").result(self.get_binding)
      @index_contents[@controller] = required_sitemaps

      # We have the markup for sitemap. Writing this into public directory.
      write_sitemap(sitemap_xml, "sitemap-#{@controller}-#{counter+1}.xml")
    }

    ## Generating a sitemap index file too.
    sitemap_index_xml = get_sitemap_erb("sitemap-index").result(self.get_binding)
    write_sitemap(sitemap_index_xml, "sitemap-index.xml")
  end

end
