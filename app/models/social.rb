class Social < ActiveRecord::Base
  before_validation :check_url
  after_update :fill_new_title
  
  ## SCOPES
  scope :order_by_date, -> { order('created_at DESC')}

  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
  validates_presence_of :url
  validates :url, :url => {:allow_blank => false, :verify => [:resolve_redirects]}

  def fill_new_title
    # Net::HTTP.get(URI("#{self.url}")) =~ /<title>(.*?)<\/title>/
    # self.title = $1
    # self.save!
    unless self.new_record?
      if self.changed?
        self.update_column('title', self.title)
      end
    end
  end

  def check_url
    add_http
    add_title
  end

  private
  
  def add_http
    unless self.url.to_s.match(/^https?\:\/\//)
      self.url = "http://#{self.url}"
    end
  end

  def add_title
    splitted = self.url.split(".")
    if splitted[0].include? "www"
      title = splitted[1]
    else
      splitted = splitted[0].split("//")
      if splitted[0].include? "http"
        title = splitted[1]
      end
    end
    self.title = title
  end
end
