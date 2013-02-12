class UsersController < InheritedResources::Base
  before_action :find_near, :only => [:show, :near_coordinates]

  def show
    @json = resource.to_gmaps4rails
    
    show!
  end

  def near_coordinates
    @near_coords = @near.map { |n| [n.latitude, n.longitude] }
    if request.xhr?
      render :json => @near_coords
    end
  end
  
  def tags
    @tag = Tag.find_by name: params[:tag]
    scope = @tag.users
    @json = scope.to_gmaps4rails
    @users = scope.paginate(:page => params[:page])
  end

  def find_near
    lat = resource.latitude
    lng = resource.longitude
    range = 10
    while @near.nil? || @near.count < 5
      @near = User.near([lat, lng], range).limit(5) # miles
      range += 50
      if range >= 500
        break
      end
    end
    @near = @near.where('id != ?', @user.id)
  end
end
