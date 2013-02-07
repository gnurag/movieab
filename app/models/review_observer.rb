class ReviewObserver < ActiveRecord::Observer
  observe :review, :stash
  
  # Upon creation of a new stash entry, add an entry to user's update.
  def after_save(review)
#     update = UserUpdate.new
#     update.user_id = review.user.id
#     update.update_type = review.class.to_s.downcase
#     update.title_id = review.title_id
    Rails.logger.debug 'After save observer'
  end

  def after_create(r)
    Rails.logger.debug 'After create observer'
  end
end
