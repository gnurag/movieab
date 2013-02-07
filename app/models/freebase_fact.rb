class FreebaseFact < ActiveRecord::Base
  belongs_to :title

  ## 
  # This function adds or updates freebase facts in the database. The parameter fact is a single line from 
  # film/film.tsv data. These lines are tab separated values and have to be parsed the ugly way.
  def self.add_update_fact(fact)
    fa = fact.split("\t")
    fact_title = fa[0]
    fact_release_date = (fa[2] == "") ? nil : ((fa[2].length == 4) ? fa[2].to_i : DateTime.parse(fa[2]).year)
    title = Title.find(:all, :conditions => ["title = ? ", fact_title])
    if title and title.length > 0
      if title.length == 1
        fb = FreebaseFact.new
        fb.title_id = title[0].id
        fb.freebase_id = fa[1]
        fb.initial_release_date = fa[2]
        fb.music = fa[8]
        fb.language = fa[9]
        fb.rating = fa[10]
        fb.estimated_budget = fa[11]
        fb.country = fa[12]
        fb.film_collections = fa[16]
        fb.soundtrack = fa[17]
        fb.genre = fa[19]
        fb.film_format = fa[27]
        fb.tagline = fa[34]
        fb.save
      else
        
      end
    end
  end

end



##
# Index order of fields in the freebase film/film.tsv dump file
# 0: name
# 1: id
# 2: initial_release_date
# 3: directed_by
# 4: produced_by
# 5: written_by
# 6: cinematography
# 7: edited_by
# 8: music
# 9: language
# 10: rating
# 11: estimated_budget
# 12: country
# 13: starring
# 14: runtime
# 15: locations
# 16: film_collections
# 17: soundtrack
# 18: featured_film_locations
# 19: genre
# 20: film_series
# 21: story_by
# 22: sequel
# 23: prequel
# 24: subjects
# 25: personal_appearances
# 26: dubbing_performances
# 27: film_format
# 28: costume_design_by
# 29: other_crew
# 30: trailers
# 31: distributors
# 32: other_film_companies
# 33: production_companies
# 34: tagline
# 35: release_date_snetflix_id
# 36: film_festivals
# 37: nytimes_id
# 38: featured_song
