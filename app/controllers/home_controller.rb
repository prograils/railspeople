class HomeController < InheritedResources::Base
  def index
    if params[:selected]
      @selected_country = Country.find_by printable_name: params[:selected] 
      scope = User.where(:country_id => @selected_country.id)
      @json = scope.to_gmaps4rails
      @people_count = scope.count
      @people = scope.paginate(:page => params[:page])
    else
      @json = User.all.to_gmaps4rails
    end
    @countries = Country.all
  end
end
