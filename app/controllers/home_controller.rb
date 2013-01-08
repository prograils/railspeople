class HomeController < InheritedResources::Base
  def index
    @json = User.all.to_gmaps4rails
  end
end
