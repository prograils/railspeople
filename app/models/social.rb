class Social < ActiveRecord::Base
  after_create :fill_title
  ## SCOPES
  scope :order_by_date, -> { order('created_at DESC')}

  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
  validates_presence_of :url
  validates :url, :url => {:allow_blank => false, :verify => [:resolve_redirects]}

  def fill_title
    # Net::HTTP.get(URI("#{self.url}")) =~ /<title>(.*?)<\/title>/
    # self.title = $1
    # self.save!
    splitted = self.url.split(".")
    if splitted[0].include? "www"
      self.title = splitted[1]
    else
      splitted = splitted[0].split("//")
      if splitted[0].include? "http"
        self.title = splitted[1]
      end
    end
    self.save!
  end
end
