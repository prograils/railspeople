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
      @credentials.user = user
    end
    @credentials.save!
  end

  def do_auth_for_signed_user
    flash[:notice] = if @credentials.nil?
      create_credentials(current_user) ? "Succesfull merged with #{@provider}" : "Unsuccesfull merged with #{@provider}"
    elsif @credentials.user.id == current_user.id
      "Account has previously merged with #{@provider}"
    else
      "The system has an account with the same #{@provider}. Sign in by #{@provider} and delete them. At the end add this #{@provider} to the present account."
    end
    flash[:alert] = current_user.errors.full_messages.to_sentence if current_user.invalid?
    redirect_to edit_user_registration_url
  end

  def do_auth_for_new_user
    if @registration_is_allowed == true
      @user = User.find_or_create_for_oauth(@auth, @credentials, @provider)
      create_credentials(@user) if @credentials.nil?
    else
      @user = User.find_for_oauth(@credentials)
    end
    if @user.present?
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "#{@provider}"
        sign_in @user, event: :authentication
        @user.valid? ? (redirect_to root_url) : (redirect_to edit_user_registration_url)
        flash[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
      else
        redirect_to new_user_registration_url
      end
    else
      flash[:alert] = "Sorry, registration is not allowed at this moment"
      redirect_to root_url
    end
  end

  def do_auth
    set_auth_vars(request.env["omniauth.auth"])
    if current_user
      do_auth_for_signed_user
    else
      do_auth_for_new_user
    end
  end

  def Auth failure
    redirect_to new_user_registration_url,
    :notice => "Auth failure, try again or register a new account below:"
  end
  
  alias_method :facebook, :do_auth
  alias_method :twitter, :do_auth
  alias_method :github, :do_auth
end
