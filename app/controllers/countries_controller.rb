class CountriesController < InheritedResources::Base
  
  def new
    @country = Country.new
  end

  def create
    @country = Country.new(params[:country])
  end

  def country_params
    params.require(:country).permit(
      :name
      :printable_name
      :iso
      :iso3
      :numcode
      :lat
      :lng
    )
  end
  private :country_params
end

