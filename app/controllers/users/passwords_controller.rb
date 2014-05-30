class Users::PasswordsController < Devise::PasswordsController
  def new
    super
  end


  private 
    def resource_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
