class Relationship < ActiveRecord::Base
  ## To excend the basic relationship functionality, grok:
  ## http://ruby.railstutorial.org/chapters/following-users#sec:following

  attr_accessible :followed_id
  
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
  


end
