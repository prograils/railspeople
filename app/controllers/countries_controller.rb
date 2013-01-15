class CountriesController < InheritedResources::Base
  
  def new
    @country = Country.new
  end

  def create
    @country = Country.new(params[:country])
  end

  def countries_selection
    @country = Country.find(params[:id])
    if request.xhr?
      render :json => @country
    end
  end

  def country_params
    params.require(:country).permit(
      :name,
      :printable_name,
      :iso,
      :iso3,
      :numcode,
      :lat,
      :lng
    )
  end
  private :country_params
end

