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

  ## VALIDATIONS
  validates_presence_of :email, :username, :first_name, :last_name, :country_id, :latitude, :longitude
  validates :blog_url, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :twitter, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :facebook, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :google_plus, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :github, :url => {:allow_blank => true, :verify => [:resolve_redirects]}
  validates :stackoverflow, :url => {:allow_blank => true, :verify => [:resolve_redirects]}

  ## BEFORE & AFTER
  after_validation :reverse_geocode  # auto-fetch address

  def gmaps4rails_address
    "#{self.country}"
  end
  
  def to_s
    "#{self.first_name} #{self.last_name}"
  end
end
