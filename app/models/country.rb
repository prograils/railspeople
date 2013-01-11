class Country < ActiveRecord::Base
  has_many :users
  scope :order_by_users, -> { order('users_count DESC')}
end
