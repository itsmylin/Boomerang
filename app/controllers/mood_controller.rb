class MoodController < ApplicationController
  require 'date'
  def index
    @interestList=Interest.all

# Function to convert interest list into chunks of 3 for display
    @interestChunks =  []
    @counter = 0
    @helperArr =[]
    @interestList.each do  |interest|
      if @counter == 2
        @helperArr << interest
        @interestChunks << @helperArr
        @helperArr = []
        @counter = 0
      else
        @helperArr << interest
        @counter += 1
      end
    end
   puts @interestChunks



  end
  def create
    session[:interest_id] = params[:interest_id]
    puts params
    if user_signed_in?
      @user_id = current_user[:id]
      @interest_id = params[:interest_id]
      #map = { userID: @user_id, interestID:@interest_id }
      #puts map
      @update_user = UserInterestMapping.where(userID: @user_id).first()
      if @update_user == nil
        UserInterestMapping.create( userID: @user_id, interestID:@interest_id )
      else
        if @update_user.interestID == @interest_id.to_s
          @update_user.save
        elsif @update_user.interestID != @interest_id.to_s
          @update_user.interestID = @interest_id
          @update_user.save
        end
      end
    end
    redirect_to meet_index_path
  end

end
