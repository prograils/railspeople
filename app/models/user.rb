class User < ActiveRecord::Base
  acts_as_gmappable :process_geocoding => false
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def gmaps4rails_address
    "#{self.country}"
  end
  
  self.per_page = 20

end
