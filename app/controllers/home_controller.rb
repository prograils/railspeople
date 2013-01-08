class HomeController < InheritedResources::Base
  def index
    if params[:selected]
      scope = User.where(:country => params[:selected])
      @json = scope.to_gmaps4rails
      @people_count = scope.count
      @people = scope.paginate(:page => params[:page])
    else
      @json = User.all.to_gmaps4rails
    end
    @countries_printable_names = Country.printable_names
  end
end
