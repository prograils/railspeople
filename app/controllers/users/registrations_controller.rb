class Users::RegistrationsController < Devise::RegistrationsController

  def new
    @json = User.new.to_gmaps4rails
    super
  end

  def resource_params

    params.require(:user).permit(
      :username,
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :current_password,
      :latitude,
      :longitude,
      :country_id,
      :bio,
      :twitter,
      :facebook,
      :google_plus,
      :github,
      :stackoverflow,
      :tag_names
    )
  end
  private :resource_params
end
