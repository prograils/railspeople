class HomeController < InheritedResources::Base
  def index
    @json = User.all.to_gmaps4rails
    @countries_printable_names = Country.printable_names
  end
end
