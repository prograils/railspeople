class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def initialize
    @registration_is_allowed = true
  end

  def facebook
    if @registration_is_allowed == true
      @user = User.find_or_create_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    else
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    end

    if @user.present?
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in @user, :event => :authentication
        if (@user.latitude.blank? || @user.longitude.blank?)
          @user.country_id = nil
          redirect_to edit_user_registration_url
        else
          redirect_to root_url
        end
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    else
      flash[:notice] = "Sorry, registration is not allowed at this moment"
      redirect_to root_url
    end
  end

  def twitter
    if @registration_is_allowed == true
      @user = User.find_or_create_for_twitter(request.env["omniauth.auth"])
    else
      @user = User.find_for_twitter(request.env["omniauth.auth"])
    end

    if @user.present?
      if @user.persisted?
        sign_in @user, :event => :authentication
        notice = []
        notice << "Please select Your location" if (@user.latitude.blank? || @user.longitude.blank?)
        notice << "fill e-mail field" if @user.no_email_filled?
        notice = notice.join(" and ")
        if notice.blank?
          redirect_to root_url
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
        else
          redirect_to edit_user_registration_url
          flash[:notice] = notice
        end
      else
        redirect_to new_user_registration_url
      end
    else
      flash[:notice] = "Sorry, registration is not allowed at this moment"
      redirect_to root_url
    end
  end

  def failure
    redirect_to new_user_registration_url,
    :notice => "Auth failure, try again or register a new account below:"
  end
end