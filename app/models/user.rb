class User < ActiveRecord::Base
  acts_as_gmappable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #RAILS 4 !!!!
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  def gmaps4rails_address
    "#{self.country}"
  end
end
