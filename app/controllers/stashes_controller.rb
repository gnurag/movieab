class StashesController < ApplicationController
  layout "two-columns"
  before_filter :authenticate_user!, :except => [:index]

  def index

  end

  def create
    stash = Stash.find_or_create_by_title_id_and_user_id(params["title_id"], current_user.id)
    stash.stash_type_id = params["stash_id"]
    
    if stash.save
      current_user.user_updates.create(:message => Stash.stash_name(stash.stash_type_id),
                                       :title_id => stash.title.id,
                                       :update_type => 'stash')
      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.json { render :json => "{'status': 'ok'}" }
      end
    end
  end
end
