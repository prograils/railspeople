class Country < ActiveRecord::Base

  ## SCOPES
  scope :order_by_users, -> { order('users_count DESC')}

  ## ASSOCIATIONS
  has_many :users

  ## VALIDATIONS

  ## BEFORE & AFTER
end
