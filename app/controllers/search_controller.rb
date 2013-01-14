class SearchController < ApplicationController
  def index
    q = "#{params[:q]}"
    @results = []
    if q.length >= 3
      users = User.column_like(:username, q).paginate(:page => params[:page])
      @results = users.all
      @json = @results.to_gmaps4rails
    end
  end
end
