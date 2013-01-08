class Users::RegistrationsController < Devise::RegistrationsController
  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :latitude, :longitude)
  end
  private :resource_params
end
