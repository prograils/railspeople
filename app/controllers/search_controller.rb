class SearchController < ApplicationController
  def index
    q = "%#{params[:q]}%"
    @results = []
    if q.length >= 5
      users = User.where("username like ?", q)
      @results = users.all
      @json = @results.to_gmaps4rails
    end
  end
end
