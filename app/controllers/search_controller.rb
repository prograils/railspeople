class SearchController < ApplicationController
  def index
    q = "#{params[:q]}"
    @results = []
    if q.length >= 3
      users = User.column_like(:username, q)
      users += User.column_like(:first_name, q)
      users += User.column_like(:last_name, q)
      @results = users.uniq
      @json = @results.to_gmaps4rails
    end
  end
end
