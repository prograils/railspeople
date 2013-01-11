class Blog < ActiveRecord::Base
   ## SCOPES
  scope :order_by_date, -> { order('created_at DESC')}

  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
   validates_presence_of :title, :url, :user_id
   validates :url, :url => {:allow_blank => false, :verify => [:resolve_redirects]}

  ## BEFORE & AFTER
end
