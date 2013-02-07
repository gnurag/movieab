class UsersController < ApplicationController
  ## TODO: Render edit page again when user cannot be saved.
  before_filter :authenticate_user!, :except => [:show]

  layout "two-columns"

  def show
    user_id = Title.url_to_id(params[:id])
    @user = User.find(user_id)
  end

  def update
    current_user.fullname = params[:user][:fullname]
    current_user.location = params[:user][:location]
    current_user.website  = params[:user][:website]
    current_user.avatar   = params[:user][:avatar] if params[:user][:avatar]
    if current_user.save
      redirect_to user_path(current_user.urlid)
    else
      ## TODO: This does not work yet. 
      render :controller => 'users/registrations', :action => 'edit'
    end
  end

end
