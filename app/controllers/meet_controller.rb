class MeetController < ApplicationController
  def index
    set_interestID
    if session[:interest_id] != nil && user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).where.not(userID: current_user[:id]).sample()
    elsif session[:interest_id] != nil && !user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).sample()
    else
      @userInterestMapping = UserInterestMapping.all.sample()
    end
    #@userInterestMappingList = User.all

    # @userInterestMappingList.each do |map|
    #   @maps <<  { id: User.find(map.userID) , interest: Interest.find(map.interestID) }
    # end
    # @userInterestMappingList.each do |map|
    #   if user_signed_in?
    #     unless map.userID.to_i == current_user.id
    #       @users <<  User.find(map.userID)
    #     end
    #   else
    #     @users <<  User.find(map.userID)
    #   end
    # end
    if @userInterestMapping != nil
      @user = User.find(@userInterestMapping[:userID])
    else
      @user = nil
    end
  end
  def create
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif current_interestID == nil
      redirect_to mood_index_path
    else
      # update database
      @userInterestMappingList = UserInterestMapping.where(interestID: session[:interest_id]).where.not(userID: current_user[:id]).sample()
      @user = User.find(@userInterestMapping[:userID])
      respond_to do |format|
        format.js
      end
    end
  end
  def show
  end
  
  protected
  def set_interestID
    if user_signed_in? 
      session[:interest_id] = current_interestID
    end
  end
end
