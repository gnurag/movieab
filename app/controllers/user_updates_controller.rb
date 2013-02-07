class UserUpdatesController < ApplicationController
  layout "homepage"
  before_filter :authenticate_user!, :except => [:show]
  
  def create
    @update = current_user.user_updates.build(params[:user_update])
    @update.update_type = 'text'
    if @update.save
      flash[:success] = "Status updated"
      redirect_to root_path
    else
      @updates = current_user.feed.paginate(:page => params[:page])
      render "users/timeline"
    end
  end

  def destroy
    
  end
  
end
