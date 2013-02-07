class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  #default_url_options[:host] = "http://www.movieab.com"
  
  has_many :stashes
  has_many :watched,  :through => :stashes, :source => :title, :conditions => 'stashes.stash_type_id = 1'
  has_many :watching, :through => :stashes, :source => :title, :conditions => 'stashes.stash_type_id = 2'
  has_many :towatch,  :through => :stashes, :source => :title, :conditions => 'stashes.stash_type_id = 3'

  has_many :user_updates, :dependent => :destroy

  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships, :source => :follower

  # Thoughtbot's paperclip gem for avatar -- https://github.com/thoughtbot/paperclip
  has_attached_file :avatar, :styles => {:thumb => "48x48>", :medium => "100x100>"}, 
  :path => "#{Paperclip::STORAGE_PATH}/:attachment/:class/:id/:style/:basename.:extension",
  :url  => "/:attachment/:class/:id/:style/:basename.:extension",
  :default_url => "/:attachment/missing_:style.png"

  def urlid
    slug = self.email.split('@').first
    slug.gsub!(".","-")
    return self.email.nil? ? self.id : "#{self.id}-#{slug}"
  end
  alias :title_for_url :urlid

  # Convert the title's id to a directory hash with 2 char delimitation.
  def dirhash
    return self.id.to_s.gsub(/(.{2})(.{2}$)?/,'\1/\2')
  end


  def name
    return (self.fullname.nil? or self.fullname == '') ? self.email.split('@')[0] : self.fullname
  end

  def gravatar(size='110')
    return self.email.nil? ? "" : "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email.downcase)}?s=#{size}&d=mm"
  end

  ## Methods for accessing and managing relationships.
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def feed
    UserUpdate.from_users_followed_by(self)
  end
end
