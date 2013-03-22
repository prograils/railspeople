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
  validate :email_filled, :on => :update
  validates_presence_of :looking_for_work, :email_privacy
  validates_uniqueness_of :username
  validates :looking_for_work, :inclusion=>{:in=>(User::WORK_TYPES.values)}
  validates :email_privacy, :inclusion=>{:in=>(User::EMAIL_PRIVACY.values)}

  ## ATTR WRITERS
  attr_writer :tag_names

  ## BEFORE & AFTER
  after_validation :reverse_geocode  # auto-fetch address
  after_save :assign_tags
  after_update :check_password_changed

  def gmaps4rails_infowindow
    if self.avatar?
      "<img class=\"img-circle\" src=\"#{self.avatar.url(:medium)}\"> <a href= /users/#{self.id}-#{self.username}> #{self.to_s}</a>"
    else
      gravatar_id = Digest::MD5::hexdigest(self.email).downcase
      "<img class=\"img-circle\" src=\"http://gravatar.com/avatar/#{gravatar_id}.png?d=mm\"> <a href= /users/#{self.id}-#{self.username}> #{self.to_s}</a>"
    end
  end

  def email_filled
    errors.add(:email, ' - change to Your valid') if no_email_filled?
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

  def no_email_filled?
    email = self.email
    if (email.present?)
      index = email.index("@")
      return (email[index..-1] == "@5h0u1d-change.it")
    end
    return 0
  end

  def to_param
    "#{id}-#{username}".parameterize
  end

  def update_with_password_without_current(params={})
    params.delete(:current_password)
    puts "===========PARAMS: #{params}"

    result = update_attributes(params)
    puts "self:: #{self.errors.inspect}"
    puts "===========RES: #{result}"

    clean_up_passwords
    result
  end

  def update_without_password(params={})
    params.delete(:current_password)
    super(params)
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
          country_id: 409,
          change_password_needed: true)
      end
    end
  end

  def self.find_for_twitter(response)
    data = response.extra.raw_info
    user = User.find_by_twitter_id(data["id"]) || nil
    user
  end

  def self.find_or_create_for_twitter(response)
    data = response.extra.raw_info
    if user = User.find_by_twitter_id(data["id"])
      user
    else # Create a user with a stub password.
      uname = self.find_or_create_username_for_twitter(data["screen_name"])
      first_name, last_name = data["name"].split

      user = User.new(
        username: "#{uname}",
        email: "#{self.temporary_email}",
        password: Devise.friendly_token[0,20],
        first_name: first_name || "u_firstname",
        last_name: last_name || "u_lastname",
        country_id: 409,
        change_password_needed: true)

      user.twitter_id = data["id_str"]
      user.twitter_screen_name = data["screen_name"]
      user.twitter_display_name = data["name"]

      user.save
      user
    end
  end

  def self.temporary_email
    email_addr = "your.email-"
    (1.. 8).collect{ |n|
        chr =  (48 + rand(9)).chr
        email_addr  << chr
      }.join

     email_addr += "@5h0u1d-change.it"
     email_addr
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

  def self.find_or_create_username_for_twitter(screen_name)
    if User.exists?(:username => screen_name)
      screen_name += "_"
      (1.. 8).collect{ |n|
        chr =  (48 + rand(9)).chr
        screen_name  << chr
      }.join
    else
      #do nothing
    end
    screen_name
  end

  def check_password_changed
    if encrypted_password_changed?
      self.update_column(:change_password_needed, false)
    end
  end

end
