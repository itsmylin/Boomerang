class MeetController < ApplicationController
  def index
    set_interestID
    if session[:interest_id] != nil && user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).where.not(userID: current_user[:id])
    elsif session[:interest_id] != nil && !user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id])
    else
      @userInterestMapping = UserInterestMapping.all
    end
    #@userInterestMappingList = User.all
    @users = []
    # @userInterestMappingList.each do |map|
    #   @maps <<  { id: User.find(map.userID) , interest: Interest.find(map.interestID) }
    # end
    if @userInterestMapping != nil
      @userInterestMapping.each do |map|
        @users <<  User.find(map.userID)
      end
    else
      @users = nil
    end
    session[:users] = @users
    puts @users
    puts 'asdasda'
    puts session[:users].inspect
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
  end
  def create
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif current_interestID == nil
      redirect_to mood_index_path
    else
      puts "I'm here"
      puts session[:users]
      puts "I'm here"
      session[:users].shift 
      puts session[:users]
      if session[:users] != []
        @users =  [User.new(session[:users][0])]
      else
        @users = nil
      end
      puts @users.inspect
      puts @users.first.inspect
      # update database
      #@userInterestMappingList = UserInterestMapping.where(interestID: session[:interest_id]).where.not(userID: current_user[:id]).sample()
      #@user = User.find(@userInterestMapping[:userID])
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
