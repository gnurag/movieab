module TitlesHelper
  def genere
    if @title.generes and @title.generes.length > 0
      return @title.generes.collect{|g| g.name}.join(', ')
    else
      return @title.main_genere.nil? ? "Not applicable." : @title.main_genere 
    end  
  end

  def studio_names
    if @title.studios and @title.studios.length > 0
      return @title.studios.collect{|g| g.name}.join(', ')
    else
      return ""
    end
  end

  def reviews_url
    return "/titles/reviews/" + @title.title_for_url
  end

  def title_url
    return url_for(:controller => "titles", :action => "show", :only_path => false, :id => @title.title_for_url)
  end
end
