class MatchController < ApplicationController
  def index
    set_interestID
    if session[:interest_id] != nil && user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).where.not(userID: current_user[:id]).order("RANDOM()")
    elsif session[:interest_id] != nil && !user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).order("RANDOM()").limit(3)
    else
      @userInterestMapping = UserInterestMapping.all.order("RANDOM()").limit(3)
    end
    @users = []

    if @userInterestMapping != nil
      if session[:interest_id] != nil && user_signed_in?
        @uumap = UserUserMapping.find_by_primeUserID(current_user[:id])
        puts @uumap.inspect
        @sentList =  @uumap["sent"].split(',')
        @completematchList =  @uumap["completematch"].split(',')
        @nomatchList =  @uumap["nomatch"].split(',')
        @userInterestMapping.each do |map|
          unless @sentList.include?(map.userID) || @nomatchList.include?(map.userID) || @completematchList.include?(map.userID)
              @users << User.find(map.userID)
          end
          break if @users.length == 3
        end
      else
        @userInterestMapping.each do |map|
          @users <<  User.find(map.userID)
        end
      end
    else
      @users = nil
    end

    puts @users
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
    puts current_user
    @userID=params[:primuser]
    @interestID = params[:interestID]
    @userInterestMapping = UserInterestMapping.where(interestID: @interestID).where.not(userID: @userID).order("RANDOM()").limit(1)
    @users = User.find(@userInterestMapping[0].userID);
     respond_to do |format|
         msg = { :status => "ok", :message => "Success!", :data => @users }
         format.json  { render :json => msg } # don't do msg.to_json
     end
  end
  protected
  def set_interestID
    if user_signed_in?
      session[:interest_id] = current_interestID
    end
  end
end
