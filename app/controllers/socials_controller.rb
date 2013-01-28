class SocialsController < ApplicationController

  def social_params
    params.require(:social).permit(
      :user_id,
      :title,
      :url
      )
  end
  private :social_params
end
