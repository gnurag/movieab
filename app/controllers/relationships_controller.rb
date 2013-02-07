class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    current_user.user_updates.create(:message => "#{current_user.name} started following #{@user.name}'s updates.",
                                     :friend_id => @user.id,
                                     :update_type => 'friend')
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end
end
