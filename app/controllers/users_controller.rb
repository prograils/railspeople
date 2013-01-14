class UsersController < InheritedResources::Base
  def show
    lat = resource.latitude
    lng = resource.longitude

    @near = User.near([lat, lng], 50).limit(5) # 50 miles
    @near = @near.where('id != ?', @user.id)
    @json = resource.to_gmaps4rails
    
    show!
  end
  
  def tags
    @tag = Tag.find_by name: params[:tag]
    scope = @tag.users
    @json = scope.to_gmaps4rails
    @users = scope.paginate(:page => params[:page])
  end
end
