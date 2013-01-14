class Users::RegistrationsController < Devise::RegistrationsController

  def new
    @json = User.new.to_gmaps4rails
    super
  end

  def update
    # required for settings form to submit when password is left blank
    if (resource_params && resource_params[:password].blank?)
      resource_params.delete("password")
      resource_params.delete("password_confirmation")
    end
    resource_params.delete("current_password")

    @user = User.find(current_user.id)

    if @user.update_attributes(resource_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def resource_params
    @resource_params ||= params.require(:user).permit(
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
      :tag_names,
      :blogs_attributes =>[:id, :user_id, :title, :url, :_destroy]
    )
  end
  private :resource_params
end
