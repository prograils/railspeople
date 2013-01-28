module UsersHelper

  def find_asset(name)
    Rails.application.assets.find_asset(name).nil? ? false : true
  end

end
