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
         :rememberable, :trackable, :omniauthable

  ## GMAP
  acts_as_gmappable process_geocoding: false
  reverse_geocoded_by :latitude, :longitude

  ## PAPERCLIP
  has_attached_file :avatar, styles: { medium: "84x84#", thumb: "40x40#" }

  ## SCOPES

  ## ASSOCIATIONS
  belongs_to :country, counter_cache: true
  has_many :blogs, dependent: :destroy
  has_many :socials, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :o_auth_credentials, dependent: :destroy

  ## ANAF
  accepts_nested_attributes_for :socials, allow_destroy: true, reject_if: proc{|p| p['url'].blank?}
  accepts_nested_attributes_for :blogs, allow_destroy: true, reject_if: proc{|p| p['url'].blank?}

  ## ATTR WRITERS & ACCESSORS
  attr_writer :tag_names
  attr_accessor :country_validation
  attr_accessor :first_name_validation
  attr_accessor :last_name_validation

  ## VALIDATIONS
  validates :username,
            uniqueness: true
  validates :username, :looking_for_work, :email_privacy,
            presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }
  validate :email_filled, on: :update
  validates :first_name,
            presence: true,
            on: :create,
            if: proc{|u| u.first_name_validation} #TODO test
  validates :last_name,
            presence: true,
            on: :create,
            if: proc{|u| u.last_name_validation} #TODO test
  validates :country_id,
            presence: true,
            on: :create,
            if: proc{|u| u.country_validation} #TODO test
  validates :country_id, :first_name, :last_name,
            presence: true,
            on: :update #TODO test
  validates :password,
            presence: true,
            confirmation: true,
            length: {within: 6..40},
            on: :create
  validates :password,
            confirmation: true,
            length: {within: 6..40},
            allow_blank: true,
            on: :update,
            unless: proc{|u| u.change_password_needed} #TODO test
  validates :password,
            confirmation: true,
            length: {within: 6..40},
            presence: true, #allow_blank: false,
            on: :update,
            if: proc{|u| u.change_password_needed} #TODO test
  validates :looking_for_work,
            inclusion: {in: (User::WORK_TYPES.values)}
  validates :email_privacy,
            inclusion: {in: (User::EMAIL_PRIVACY.values)}

  ## BEFORE & AFTER
  after_initialize :assign_defaults
  after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? and obj.longitude.present? and (obj.latitude_changed? or obj.longitude_changed?) }
  after_save :assign_tags
  after_update :check_password_changed

  def assign_defaults
    self.country_validation = true
    self.first_name_validation = true
    self.last_name_validation = true
  end

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
    self.first_name.present? && self.last_name.present? ?
     "#{self.first_name} #{self.last_name}" :
     "noname (#{self.username})"
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

  def email_filled
    errors.add(:email, ' - change to Your valid') if no_email_filled?
  end

  # to del
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
    result = update_attributes(params)

    clean_up_passwords
    result
  end

  def update_without_password(params={})
    params.delete(:current_password)
    super(params)
  end

  def set_attrs(auth, provider)
    if auth.extra.present?
      data = auth.extra.raw_info
      u = User.where(id: self.id)
      case provider
        when "facebook"
          u.update_all first_name: data.first_name if self.first_name.blank? && data.first_name.present?
          u.update_all last_name: data.last_name if self.last_name.blank? && data.last_name.present?
          u.update_all email: data.email if no_email_filled? && data.email.present?
          u.update_all facebook: data.username if self.facebook.blank? && data.username.present?
        when "twitter"
          u.update_all twitter: data.screen_name if self.twitter.blank? && data.screen_name.present?
        when "github"
          u.update_all github: data.login if self.github.blank? && data.login.present?
      end
    end
  end

  def profile_url(provider)
    "https://#{provider}.com/#{self[provider]}"
  end

  # Check, if user account is merged with social service
  # (str) -> bool
  def has_account_merged_with?(provider)
    self.o_auth_credentials.where(provider: provider).any?
  end

  def temporary_email
    email_addr = "your.email-"
    (1.. 15).collect{ |n|
        chr = (48 + rand(9)).chr
        email_addr << chr
      }.join

     email_addr += "@5h0u1d-change.it"
     email_addr
  end


  private

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).uniq.map do |name|
        Tag.where(name: name).first_or_create
      end
    end
  end

  def no_email_filled?
    email = self.email
    if email.present?
      index = email.index("@")
      return email[index..-1] == "@5h0u1d-change.it"
    end
    true
  end

  def self.find_for_oauth(credentials)
    credentials.present? ? credentials.user : nil
  end

  def self.find_or_create_for_oauth(auth, credentials, provider)
    if credentials.present?
      credentials.user
    else
      data = auth.extra.raw_info
      User.send("find_or_create_for_#{provider}_oauth", data, credentials)
    end
  end

  def self.find_or_create_for_facebook_oauth(data, credentials)
    if data.email.present?
      if user = User.where(email: data.email).first
        user
      else # Create a user with a stub password.
        uname = self.find_or_create_username_for_facebook(data["first_name"], data["last_name"])

        user = User.new(
          username: "#{uname}",
          email: data.email,
          password: Devise.friendly_token[0,20],
          first_name: data["first_name"] || "u_firstname",
          last_name: data["last_name"] || "u_lastname",
          facebook: data.username,
          change_password_needed: true)
        user.country_validation = false
        user.save
        user
      end
    end
  end

  def self.find_or_create_for_twitter_oauth(data, credentials)
    #Create a user with a stub password.
    uname = self.find_or_create_username(data["screen_name"])
    first_name, last_name = data["name"].split

    user = User.new(
      username: "#{uname}",
      password: Devise.friendly_token[0,20],
      first_name: first_name || "u_firstname",
      last_name: last_name || "u_lastname",
      twitter: data.screen_name,
      change_password_needed: true)
    user.email = user.temporary_email
    user.country_validation = false
    user.save
    user
  end

  def self.find_or_create_for_github_oauth(data, credentials)
    if data.email.present? && user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password.
      uname = self.find_or_create_username(data["login"])

      user = User.new(
        username: "#{uname}",
        password: Devise.friendly_token[0,20],
        github: data["login"],
        change_password_needed: true)
      user.email = user.temporary_email
      user.country_validation = false
      user.first_name_validation = false
      user.last_name_validation = false
      user.save
      user
    end
  end

  def self.find_or_create_username_for_facebook(first_n, last_n)
    first_and_last = []
    first_and_last << first_n.capitalize if first_n.present?
    first_and_last << last_n.capitalize if last_n.present?
    value = first_and_last.join("_")
    self.find_or_create_username(value)
  end

  def self.find_or_create_username(login)
    if User.exists?(username: login)
      login = self.add_num_chars(login)
    else
      #do nothing
    end
    login
  end

  def self.add_num_chars(str)
    str += "_"
      (1.. 8).collect{ |n|
        chr =  (48 + rand(9)).chr
        str  << chr
      }.join
    return str
  end

  def check_password_changed
    if encrypted_password_changed?
      self.update_column(:change_password_needed, false)
    end
  end
end
