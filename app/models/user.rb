class User < ActiveRecord::Base
  WORK_TYPES = {
    :not_looking  => 0,
    :freelance => 1,
    :full_time => 2
  }

  EMAIL_PRIVACY = {
    :anyone => 2,
    :logged_in => 1,
    :no_one => 0
  }

  # WILL_PAGINATE
  self.per_page = 20

  ## DEVISE
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # GMAP
  acts_as_gmappable :process_geocoding => false
  reverse_geocoded_by :latitude, :longitude

  # PAPERCLIP\
  has_attached_file :avatar, :styles => { :medium => "84x84#", :thumb => "40x40#" }

  ## SCOPES

  ## ASSOCIATIONS
  belongs_to :country, :counter_cache => true
  has_many :blogs, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  ## ANAF
  accepts_nested_attributes_for :blogs, :allow_destroy => true

  ## VALIDATIONS
  validates_presence_of :email, :username, :first_name, :last_name, :country_id, :latitude, :longitude
  validates_presence_of :looking_for_work, :email_privacy
  validates_uniqueness_of :username
  validates :twitter, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :facebook, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :google_plus, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :github, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :stackoverflow, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :flickr, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :delicious, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :linkedin, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :bitbucket, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :looking_for_work, :inclusion=>{:in=>(User::WORK_TYPES.values)}
  validates :email_privacy, :inclusion=>{:in=>(User::EMAIL_PRIVACY.values)}

  ## AFTER/BEFORE
  attr_writer :tag_names
  after_save :assign_tags
  ## BEFORE & AFTER
  after_validation :reverse_geocode  # auto-fetch address
  after_save :assign_tags

  def gmaps4rails_infowindow
    self.avatar? ? "<img src=\"#{self.avatar.url(:medium)}\"> <a href= /users/#{self.id}-#{self.username}> #{self.to_s}</a>"
    : "<a href= /users/#{self.id}-#{self.username}> #{self.to_s}</a>"
  end

  def gmaps4rails_address
    "#{self.country}"
  end

  def to_s
    "#{self.first_name} #{self.last_name}"
  end
  
  def self.column_like(column, value)
    table = self.arel_table
    where(table[column].matches("%#{value}%"))
  end
  
  def tag_names
   @tag_names || tags.map(&:name).join(' ')
  end

  def not_looking_for_work?
    self.looking_for_work == 0
  end

  def looking_for_freelance_work?
    self.looking_for_work == 1
  end

  def looking_for_full_time_work?
    self.looking_for_work == 2
  end

  def to_param
    "#{id}-#{username}".parameterize
  end

  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
