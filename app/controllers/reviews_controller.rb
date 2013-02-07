class ReviewsController < ApplicationController
  layout "two-columns"
  before_filter :load_title
  before_filter :authenticate_user!, :except => [:index]

  def new
    @review = @title.reviews.new
  end

  def index
  end

  def create
    @review = Review.new
    @review.title_id = @title.id
    @review.user_id = current_user.id
    @review.subject = params[:review][:subject]
    @review.review = params[:review][:review]
    if @review.save
      current_user.user_updates.create(:message => "#{current_user.name} wrote a review for #{@title.title}.",
                                       :title_id => @title.id,
                                       :update_type => 'review')
      redirect_to title_reviews_path(@title.title_for_url)
    else
      render :action => :new
    end
  end

  protected
  
  def load_title
    @title = Title.find(Title.url_to_id(params[:title_id]))
  end
end
