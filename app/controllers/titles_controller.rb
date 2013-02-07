class TitlesController < ApplicationController
  layout "two-columns"
  caches_action :home, :upcoming, :if => Proc.new{ not user_signed_in? }, :expires_in => 30.minutes
  caches_action :show, :if => Proc.new{ not user_signed_in? }, :expires_in => 1.day
  caches_action :autocomplete, :cache_path => Proc.new{ |c| "1/#{c.request.url}" }, :expires_in => 1.week

  def home
    if user_signed_in?
      @updates = current_user.feed.paginate(:page => params[:page])
      @update  = UserUpdate.new
      render "users/timeline", :layout => "homepage"
    else
      @ut = UpcomingTitle.find(:all, :include => [:title], :conditions => ['enabled = 1'], :order => 'sort_order ASC, id ASC', :limit => 30)
      @titles = @ut.collect{|t| t.title}
      @titles = @titles.delete_if{|t| t and t.synopsis.nil?}
      render "upcoming", :layout => "homepage"
    end
  end

  def upcoming
    @ut = UpcomingTitle.find(:all, :include => [:title], :conditions => ['enabled = 1'], :order => 'sort_order ASC, id ASC', :limit => 30)
    @titles = @ut.collect{|t| t.title}
    @titles = @titles.delete_if{|t| t and t.synopsis.nil?}
    respond_to do |format|
      format.html {render :layout => "homepage"} # index.html.erb
      #format.xml {render :xml => @titles, :layout => false}
    end
  end

  def search
    query = params[:query]
    if query and query.length > 0
      @matches = Hash.new
      @matches[:movies]  = []; @matches[:series] = []; @matches[:programs] = []; @matches[:discs] = []
      @matches[:people] = [];
      @matches[:exact]  = Title.find(:all, 
                           :conditions => ["title = ?", "#{params[:query]}"],
                           :order => "release_year DESC, netflix_rating DESC",
                           :limit => (query.length <= 5 ? 10 : nil))
      result,result_metadata = Title.xapian_search(params[:query])
      @matches[:spelling_correction] = result_metadata[:spelling_correction]
      
      people_result = Person.find(:all,
                          :conditions => ["name LIKE ?", "%#{params[:query]}%"], 
                          :order => "name DESC, LENGTH(name) ASC",
                          :limit => (query.length <= 5 ? 100 : nil))
      result.each{|r|
        @matches[:movies].push(r)   if r.title_type == "movies" or r.title_type == "movie"
        @matches[:series].push(r)  if r.title_type == "series"
        @matches[:programs].push(r) if r.title_type == "programs" or r.title_type == "program"
        @matches[:discs].push(r)    if r.title_type == "discs" or r.title_type == "disc"
      }
      people_result.each{|r|
        @matches[:people].push(r)
      }
      cookies["movieab-query"] = params[:query]

      respond_to do |format|
        format.xml  { render :xml => @matches}
        format.html { render :layout => "homepage"}
      end
    end
  end

  def autocomplete
    @q = params[:query].dup
    @q.gsub!(' ', '%') if not @q.nil?
    @titles = Title.find(:all, :select => [:id,:title,:release_year], 
                         :conditions => ["title like ?", "#{@q}%"],
                         :order => 'title ASC, netflix_rating DESC, release_year DESC',
                         :limit => 10)
    respond_to do |format|
      format.json { render :layout => false}
    end
  end

  # GET /titles
  def index
    @titles = Title.paginate :page => params[:page], :order => 'title ASC'
    respond_to do |format|
      format.html {render :layout => "homepage"} # index.html.erb
    end
  end

  # GET /titles/browse/1
  def browse
    @titles = Title.paginate :page => params[:page], :conditions => ["title LIKE ?", "#{params[:id]}%"], :order => 'title ASC'
    render :template => "titles/index", :layout => "homepage"
  end

  # GET /titles/1
  def show
    title_id = Title.url_to_id(params[:id])
    @title = Title.find(title_id, :include => [:nytimes_review, :google_images, :youtube_videos, :reviews, :amazon_items])

    ## Retrieve or Refresh extra movie data from netflix, nytimes, googleajax, amazon
    if @title.refresh_title_data
      @title = Title.find(title_id, :include => [:nytimes_review, :google_images, :youtube_videos, :reviews, :amazon_items])
    end
    ## For now, refresh image cache for all requests.
    @title.cache_images

    @page_title = @title.title
    @page_title += " (#{@title.release_year})" if @title.release_year and @title.release_year != ""

    @youtube_id = @title.youtube_videos.first.youtube_id if @title.youtube_videos.any?
    respond_to do |format|
      format.html {render :layout => "two-columns"} # show.html.erb
      format.xml  {render :xml => @title}
      format.js { render :template => "titles/widget", :layout => false, :content_type => "text/plain"}
    end
  end

end
