module FreebaseData
  class Film
    def self.import
      freebase_film_dump = Rails.root + "/tmp/freebase/film/film.tsv"
      first_line_skipped = false   # The first line of dump contains column desc, so a flag to skip it
      if File.readable?(freebase_film_dump) and File.file?(freebase_film_dump)
        File.foreach(freebase_film_dump) do |line|
          FreebaseFact.add_update_fact(line) if first_line_skipped
          first_line_skipped = true
        end
      end
    end
  end
end
