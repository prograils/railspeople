class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def initialize
    @registration_is_allowed = true
    @user = nil
  end

  def set_auth_vars(auth)
    @auth = auth
    @provider = @auth['provider']
    @credentials = OAuthCredential.where(uid: @auth["uid"]).where(provider: @provider).first
  end

  def create_credentials(user)
    @credentials = OAuthCredential.new(uid: @auth["uid"], provider: @provider)
    if user.present?
      user.set_attrs(@auth, @provider)
      user.reload
      @credentials.user = user
    end
    @credentials.save!
  end

  def do_auth(provider)
    set_auth_vars(request.env["omniauth.auth"])
    if current_user
      flash[:notice] = if @credentials.nil?
        create_credentials(current_user) ? "Succesfull merged with #{provider}" : "Unsuccesfull merged with #{provider}"
      else
        if @credentials.user.id == current_user.id
          "Account has previously merged with #{provider}"
        else
          "The system has an account with the same #{provider}. Sign in by #{provider} and delete them. At the end add this #{provider} to the present account."
        end
      end
      flash[:alert] = current_user.errors.full_messages.join(', ') if current_user.invalid?
      redirect_to edit_user_registration_url
    else
      if @registration_is_allowed == true
        #@user = User.send("find_or_create_for_oauth", @auth, @credentials, provider)
        @user = User.find_or_create_for_oauth(@auth, @credentials, provider)
        create_credentials(@user) if @credentials.nil?
      else
        #@user = User.send("find_for_oauth", @credentials)
        @user = User.find_for_oauth(@credentials)
      end
      if @user.present?
        if @user.persisted?
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{provider}"
          sign_in @user, :event => :authentication
          @user.valid? ? (redirect_to root_url) : (redirect_to edit_user_registration_url)
          flash[:alert] = @user.errors.full_messages.join(', ') if @user.errors.any?
        else
          redirect_to new_user_registration_url
        end
      else
        flash[:alert] = "Sorry, registration is not allowed at this moment"
        redirect_to root_url
      end
    end
  end

  def facebook
    do_auth("facebook")
  end

  def twitter
    do_auth("twitter")
  end

  def github
    do_auth("github")
  end

  def country_is_not_set
    @user.latitude.blank? || @user.longitude.blank? || @user.country_id.blank?
  end

  def email_is_not_set
    @user.email.blank?
  end

  def Auth failure
    redirect_to new_user_registration_url,
    :notice => "Auth failure, try again or register a new account below:"
  end
end
