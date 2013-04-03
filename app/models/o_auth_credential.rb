class OAuthCredential < ActiveRecord::Base
  serialize :params

  ## TYPES
  PROVIDERS = %w( facebook twitter github )

  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
  validates :provider, :uid,
            :presence => true
  validates :uid,
            :uniqueness => {:scope => :provider}
  validates :provider,
            :uniqueness => {:scope => :user_id},
            :inclusion => {:in => OAuthCredential::PROVIDERS}

  ## ACCESSIBLE
  #attr_accessible :params, :provider, :uid

  def to_s
    "#{self.provider} (#{self.uid})"
  end
end
