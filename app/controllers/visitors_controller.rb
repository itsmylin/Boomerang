class VisitorsController < ApplicationController
  def index
    if user_signed_in?
        redirect_to mood_path
    end
  end
  def mood
  end
end
