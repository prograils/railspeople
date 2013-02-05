class AboutController < ApplicationController
  def index
    @users = User.all.count
    @countries = Country.where(["users_count > ?", 0]).order_by_users.count
  end
end
