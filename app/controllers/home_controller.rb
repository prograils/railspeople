class HomeController < InheritedResources::Base
  def index
    if params[:selected]
      @selected_country = Country.find_by printable_name: params[:selected]
      scope = User.where(:country_id => @selected_country.id)
      @json = scope.to_gmaps4rails
      @people = scope.paginate(:page => params[:page])
    else
      @json = User.all.to_gmaps4rails
    end
    @countries = Country.where(["users_count > ?", 0]).order_by_users
  end
end
