class UsersController < InheritedResources::Base
  def show
    lat = resource.latitude
    lng = resource.longitude

    @near = User.near([lat, lng], 50).limit(6) # 50 miles
    @near = @near.where('id != ?', @user.id)
    @json = resource.to_gmaps4rails
    
    show!
  end
end
