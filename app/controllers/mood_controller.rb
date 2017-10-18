class MoodController < ApplicationController
  def index
    @interestList=Interest.all
  end
  def create
    session[:interest_id] = params[:interest_id]
    puts params
    if user_signed_in?
      @user_id = current_user[:id]
      @interest_id = params[:interest_id]
      #map = { userID: @user_id, interestID:@interest_id }
      #puts map
      UserInterestMapping.create( userID: @user_id, interestID:@interest_id )
    end
    redirect_to match_index_path
  end
    
  
end
