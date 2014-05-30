class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def new
    @json = User.new.to_gmaps4rails
    super
  end

  def create
    super
    unless resource.country_id.nil?
      if resource.latitude.nil? || resource.longitude.nil?
        @country = Country.find(resource.country_id)
        resource.update_attributes(:latitude => @country.lat, :longitude => @country.lng, :zoom => 6)
      end
    end
    resource.socials.each { |s| s.user_id = current_user }
  end

  def edit
    #resource.assign_attributes(resource_params) if resource_params.present?
    render :edit
  end

  def update
    @user = current_user#User.find(current_user.id)
    successfully_updated = if @user.change_password_needed?
      @user.update_with_password_without_current(resource_params)
    elsif needs_password?(@user, resource_params)
      @user.update_with_password(resource_params)
    else
      @user.update_without_password(resource_params)
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(*permitted_params) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(*permitted_params) }
    end

    def resource_params
      params.require(:user).permit(*permitted_params)
    end

    def permitted_params
      [
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
        :change_password_needed,
        :skip_country_validation,
        :skip_email_validation,
        :blogs_attributes => [:id, :user_id, :title, :url, :_destroy],
        :socials_attributes => [:id, :user_id, :title, :url, :_destroy]
      ]
    end

  private
    def needs_password?(user, params)
      user.email != params[:email] || !params[:password].empty?
    end
end
