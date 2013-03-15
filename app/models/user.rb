class User < ActiveRecord::Base

  ## TYPES
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

  ## WILL_PAGINATE
  self.per_page = 20

  ## DEVISE
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  ## GMAP
  acts_as_gmappable :process_geocoding => false
  reverse_geocoded_by :latitude, :longitude

  ## PAPERCLIP
  has_attached_file :avatar, :styles => { :medium => "84x84#", :thumb => "40x40#" }

  ## SCOPES

  ## ASSOCIATIONS
  belongs_to :country, :counter_cache => true
  has_many :blogs, :dependent => :destroy
  has_many :socials, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  ## ANAF
  accepts_nested_attributes_for :socials, :allow_destroy => true
  accepts_nested_attributes_for :blogs, :allow_destroy => true

  ## VALIDATIONS
  validates_presence_of :email, :username, :first_name, :last_name, :country_id
  validates_presence_of :looking_for_work, :email_privacy
  validates_uniqueness_of :username
  validates :looking_for_work, :inclusion=>{:in=>(User::WORK_TYPES.values)}
  validates :email_privacy, :inclusion=>{:in=>(User::EMAIL_PRIVACY.values)}

  ## ATTR WRITERS
  attr_writer :tag_names

  ## BEFORE & AFTER
  after_validation :reverse_geocode  # auto-fetch address
  after_save :assign_tags

  def gmaps4rails_infowindow
    if self.avatar?
      "<img class=\"img-circle\" src=\"#{self.avatar.url(:medium)}\"> <a href= /users/#{self.id}-#{self.username}> #{self.to_s}</a>"
    else
      gravatar_id = Digest::MD5::hexdigest(self.email).downcase
      "<img class=\"img-circle\" src=\"http://gravatar.com/avatar/#{gravatar_id}.png?d=mm\"> <a href= /users/#{self.id}-#{self.username}> #{self.to_s}</a>"
    end
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
      self.tags = @tag_names.split(/\s+/).uniq.map do |name|
        Tag.where(:name => name).first_or_create
      end
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    user = User.where(:email => data.email).first || nil
    user
  end

  def self.find_or_create_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if data.email.present?
      if user = User.where(:email => data.email).first
        user
      else # Create a user with a stub password.
        uname = self.find_or_create_username(data["first_name"], data["last_name"])
        User.create!(
          username: "#{uname}",
          email: data.email,
          password: Devise.friendly_token[0,20],
          first_name: data["first_name"] || "u_firstname",
          last_name: data["last_name"] || "u_lastname",
          country_id: 409)
      end
    end
  end

  def self.find_or_create_username(first_n, last_n)
    first_and_last = []
    first_and_last << first_n.capitalize if first_n.present?
    first_and_last << last_n.capitalize if last_n.present?
    value = first_and_last.join("_")
    if User.exists?(:username => value)
      value += "_"
      (1.. 8).collect{ |n|
        chr =  (48 + rand(9)).chr
        value  << chr
      }.join
    else
      #do nothing
    end
    value
  end

end
