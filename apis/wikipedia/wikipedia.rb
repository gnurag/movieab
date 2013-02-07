require 'roxml'

require "#{File.dirname(__FILE__)}/wikipedia_abstract.rb"

module Wikipedia
  class DataUtils
    def self.import_abstract(abstract_file)
      if File.readable?(abstract_file) and File.file?(abstract_file)
        doc_entry = ""
        collect_xml = false
        counter     = 0
        milestone   = 10000
        File.foreach(abstract_file) do |line|
          if line.include?("<doc>") and line.strip == "<doc>"
            doc_entry   = ""        # Resets the previous doc xml.
            collect_xml = true
          end
          if line.include?("</doc>") and line.strip == "</doc>"
            doc_entry += line
            TitleWiki.add_update_article(Wikipedia::Abstract::Doc.parse(doc_entry))
            collect_xml = false
            counter += 1
            puts "#{counter} articles processed" if (counter % milestone) == 0
          end
          doc_entry += line if collect_xml
        end
      end
    end
  end
end
