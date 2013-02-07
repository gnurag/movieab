class PeopleController < ApplicationController
  caches_action :show, :if => Proc.new{ not user_signed_in? }, :expires_in => 1.day

  # GET /people
  def index
    @people = Person.paginate :page => params[:page], :order => 'name ASC'
    respond_to do |format|
      format.html {render :layout => "homepage"} # index.html.erb
    end
  end

  # GET /people/browse/1
  def browse
    @people = Person.paginate :page => params[:page], :conditions => ["name LIKE ?", "#{params[:id]}%"], :order => 'name ASC'
    render :template => "people/index", :layout => "homepage"
  end

  # GET /people/1
  def show
    person_id = Title.url_to_id(params[:id])
    @person = Person.find(person_id, :include => [:titles, :google_images])

    if @person.refresh_data
      @person = Person.find(person_id, :include => [:titles, :google_images])
    end

    @page_title = @person.name + " biography, photos and posters"

    respond_to do |format|
      format.xml  {render :xml => @person}
      format.html {render :layout => "two-columns-people"} # show.html.erb
    end
  end
end
