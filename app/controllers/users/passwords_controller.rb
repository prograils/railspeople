class Users::PasswordsController < Devise::PasswordsController
  def new
    super
  end


  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  private :resource_params
end
