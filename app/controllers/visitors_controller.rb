class VisitorsController < ApplicationController
  def indexx
    if user_signed_in?
        redirect_to mood_path
    end
  end
  def mood
  	@interestList=Interest.all
  end
end
