class BlogsController < ApplicationController
  def blog_params
    params.require(:blog).permit(
      :user_id,
      :title,
      :url
    )
  end
  private :blog_params
end
