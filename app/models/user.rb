class User < ActiveRecord::Base
 
  # WILL_PAGINATE 
  self.per_page = 20

  ## DEVISE
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # GMAP
  acts_as_gmappable :process_geocoding => false
  reverse_geocoded_by :latitude, :longitude

  ## SCOPES

  ## ASSOCIATIONS
  belongs_to :country, :counter_cache => true
  has_many :blogs, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  ## VALIDATIONS
  validates_presence_of :email, :username, :first_name, :last_name, :country_id, :latitude, :longitude
  validates_uniqueness_of :username
  validates :twitter, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :facebook, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :google_plus, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :github, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :stackoverflow, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  
  ## AFTER/BEFORE

  attr_writer :tag_names
  after_save :assign_tags
  ## BEFORE & AFTER
  after_validation :reverse_geocode  # auto-fetch address
  after_save :assign_tags

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

  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
