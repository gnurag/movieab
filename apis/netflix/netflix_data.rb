module Netflix
  class DataUtils
    def self.import_catalog(catalog_file)
      if File.readable?(catalog_file) and File.file?(catalog_file)
        title_entry = ""
        collect_xml = false
        counter     = 0
        milestone   = 1000
        File.foreach(catalog_file) do |line|
          if line.strip == "<title_index_item>"
            title_entry = ""        # Resets the previous title xml.
            collect_xml = true
          end
          if line.strip == "</title_index_item>"
            title_entry += line
            title_roxml = Netflix::CatalogResponse::TitleIndexItem.parse(title_entry)
            if title_roxml and not title_roxml.id.nil?
              Title.add_update_title(title_roxml)
            end
            collect_xml = false
            counter += 1
            puts "#{counter} titles processed" if (counter % milestone) == 0
          end
          title_entry += line if collect_xml
        end
      end
    end

    def self.refresh
      Netflix::Movie.nfindex_download
      Netflix::DataUtils.import_catalog("#{Rails.root.to_s}/tmp/index.xml")
      Sitemap.new.generate
      `rake xapian:rebuild_index models="Title" RAILS_ENV=production`
    end
  end
end
