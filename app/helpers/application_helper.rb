module ApplicationHelper
  def email_is_visible?
    user_signed_in? && @user.email_privacy == 1 || @user.email_privacy == 2
  end
end
