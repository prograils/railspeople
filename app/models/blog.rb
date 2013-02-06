class Blog < ActiveRecord::Base
  require "net/http"
   ## SCOPES
  scope :order_by_date, -> { order('created_at DESC')}

  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
   validates_presence_of :url, :user_id
   # validates :url, :url => {:allow_blank => false, :verify => [:resolve_redirects]}

  ## BEFORE & AFTER
  before_save :check_url
  after_update :fill_new_title

  def server_response=(resp)
    @server_response = resp
  end

  def server_response
    @server_response
  end

  def check_url
    @server_response = nil

    self.url.gsub!(/ /,'') # remove redundant spaces before valid url adress

    add_http
    isOk = 1

    begin
      curl = Curl::Easy.new(self.url)
      curl.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20100101 Firefox/11.0"
      curl.verbose = true
      curl.follow_location = true
      curl.max_redirects = 3
      curl.timeout = 30
      curl.perform

    rescue Exception => e
      Rails.logger.error("---------- Curl exception: -------------")
      Rails.logger.error("#{e.message}")
      isOk = 0
    end
    Rails.logger.error("---------- Is ok?-------------")
    Rails.logger.error("#{isOk}")
    if (isOk == 1)
      self.url = curl.last_effective_url # last -real- url after redirections
      @server_response = curl.body_str
      if @server_response != ""
        generate_title
      end
    end
    return isOk
  end

  def fill_new_title
    if self.changed?
      generate_title
      self.update_column('title', self.title)
    end
  end

  private
  def add_http
    unless self.url.to_s.match(/^https?\:\/\//)
      self.url = "http://#{self.url}"
    end
  end

  def generate_title()
    all_titles = server_response.to_s.match(/<title>\s*(.*)\s*<\/title>/)

    title = all_titles[1] if all_titles.present?
    new_title = ""
    if (title.present?)
        new_title = title.force_encoding('utf-8')
    else
      new_title = self.url.to_s
    end
    self.title = new_title
  end

end
