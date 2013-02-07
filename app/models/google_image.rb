class GoogleImage < ActiveRecord::Base

  def self.populate_images(resource)
    GoogleAjax.referer = "www.movieab.com"
    if resource.class == Title
      search_string = resource.title + " #{resource.release_year.to_s} movie"
      resource_type = "title"
    elsif resource.class == Person
      search_string = resource.name + resource.role
      resource_type = "person"
    end
    
    image_results   = nil
    begin
      ## Setting this flag just before searching images to avoid race condition. 
      ## AjaxSearch takes some time, and if two mongrels get triggered, then we 
      ## are left with several duplicate image results.
      resource.gi_synced = true
      resource.save
      image_results = GoogleAjax::Search.images(search_string)
      if image_results and image_results[:results] and image_results[:results].length > 0
        image_results[:results].each{|gi|
          img = GoogleImage.new
          img.resource_type = resource_type
          img.resource_id = resource.id
          img.gsearch_result_class = gi[:gsearch_result_class]
          img.title = gi[:title]
          img.title_no_formatting = gi[:title_no_formatting]
          img.content = gi[:content]
          img.content_no_formatting = gi[:content_no_formatting]
          img.image_id = gi[:image_id]
          img.width = gi[:width]
          img.height = gi[:height]
          img.tb_width = gi[:tb_width]
          img.tb_height = gi[:tb_height]
          img.unescaped_url = gi[:unescaped_url]
          img.visible_url = gi[:visible_url]
          img.url = gi[:url]
          img.tb_url = gi[:tb_url]
          img.original_context_url = gi[:original_context_url]
          img.save
        }
      end
    rescue Exception => e
      puts e
      # TODO: add logging via global logger object
    end
  end
end
