class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @json = @user.to_gmaps4rails
  end
end
