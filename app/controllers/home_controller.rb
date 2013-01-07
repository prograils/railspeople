class HomeController < ApplicationController
  def index
    @json = User.all.to_gmaps4rails
  end
end
