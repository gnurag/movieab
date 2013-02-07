class TitleWiki < ActiveRecord::Base
  ## Only used for bulk importing/refreshing data from wikipedia articles xml dump.
  def self.add_update_article(abstract)
    abstract.title = abstract.title.gsub("Wikipedia:","").strip
    if valid_movie_wiki_article?(abstract)
      puts "Exists: #{abstract.title}"
    end
  end  

  def self.valid_movie_wiki_article?(article)
    valid = false
    article.links.sublink.each{|link|
      if link.linktype == "nav"
        if link.anchor and link.anchor.downcase.include?("plot")
          searchable_title = article.title
          if Title.exists?(:title => searchable_title)
            valid = true
          end
        end
      end
    }
    return valid
  end
end
