class User < ActiveRecord::Base
  acts_as_gmappable :process_geocoding => false
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates_presence_of :username, :first_name, :last_name, :country, :latitude, :longitude
  validates :blog_url, :url => true, :allow_blank => true
  validates :twitter, :url => true, :allow_blank => true
  validates :facebook, :url => true, :allow_blank => true
  validates :google_plus, :url => true, :allow_blank => true
  validates :github, :url => true, :allow_blank => true
  validates :stackoverflow, :url => true, :allow_blank => true
  
  def gmaps4rails_address
    "#{self.country}"
  end
  
  self.per_page = 20

end
