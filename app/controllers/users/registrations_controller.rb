class Users::RegistrationsController < Devise::RegistrationsController

  def new
    @json = User.new.to_gmaps4rails
    super
  end

  def create
    super
    if resource.latitude.nil? || resource.longitude.nil?
      @country = Country.find(resource.country_id)
      resource.update_attributes(:latitude => @country.lat, :longitude => @country.lng, :zoom => 6)
    end
    resource.socials.each { |s| s.user_id = current_user }
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
      :zoom,
      :country_id,
      :bio,
      :gtalk,
      :skype,
      :jabber,
      :tag_names,
      :looking_for_work,
      :search_visibility,
      :im_privacy,
      :email_privacy,
      :avatar,
      :blogs_attributes =>[:id, :user_id, :title, :url, :_destroy],
      :socials_attributes => [:id, :user_id, :title, :url, :_destroy]
    )
  end
  private :resource_params
end
