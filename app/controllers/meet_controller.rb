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
  def createxx
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
  
  def create
    @fromUser=params[:primuser];
    @toUser=params[:secuser];
    @response=params[ :response];
    @presUserData=UserUserMapping.find_by primeUserID: @fromUser
    @secUserData=UserUserMapping.find_by primeUserID: @toUser

    if(@response=='Y')
      #prim user is the logged in user whereas the sec user is the one abt whom the prim user is giving prefernce(yes/no)
      @secUserReject=(@secUserData["nomatch"]).split(',')
      puts 'list of users rejected by sec User '+ @secUserReject
      @secUserLiked=(@secUserData["sent"]).split(',')
      puts 'list of users liked by sec user '+ @secUserLiked
      if(@secUserReject.include? @fromUser) #Already No from secUSer
          @presUserNoMatchDataArr=(presUserData["nomatch"]).split(',')
          @presUserNoMatchDataArr=@presUserNoMatchDataArr + @toUser #there is not diff btw who said no first ?? shu we handle this case too later?
          @presUserNoMatchData=@presUserNoMatchDataArr.join(',')
          puts 'presUserNoMatchData'+ @presUserNoMatchData
          UserUserMapping.where( primeUserID: @fromUser ).update_all( nomatch: @presUserNoMatchData )
      

      elsif(@secUserLiked.include? @fromUser) #Already Yes from secUser
        #remove 
        #
        @presUserPrfctMatchDataArr=(presUserData["completematch"]).split(',')
        @presUserPrfctMatchDataArr=@presUserPrfctMatchDataArr+@toUser
        @presUserPrfctMatchData=@presUserPrfctMatchDataArr.join(',')
          puts 'presUserPrfctMatchData'+ @presUserPrfctMatchData
        UserUserMapping.where( primeUserID: @fromUser ).update_all( completematch: @presUserPrfctMatchData )

        @secUserPrfctMatchDataArr=(secUserData["completematch"]).split(',')
        @secUserPrfctMatchDataArr=@secUserPrfctMatchDataArr+','+@fromUser
        @secUserPrfctMatchData=@secUserPrfctMatchDataArr.join(',')
        puts 'secUserPrfctMatchData'+ @secUserPrfctMatchData
        UserUserMapping.where( primeUserID: @toUser ).update_all( completematch: @secUserPrfctMatchData )




      else
          
          @presUserSentArr=(presUserData["sent"]).split(',')
          @presUserSentArr=@presUserSentArr+@toUse
          @presUserSent=@presUserSentArr.join(',')
          UserUserMapping.where( primeUserID: @fromUser ).update_all( sent: @presUserSent )


          @secUserRcv=secUserData["received"]
          @secUserRcv=@secUserRcv+","+@fromUser
          UserUserMapping.where( primeUserID: @toUser ).update_all( received: @secUserRcv )
      end
    elsif(@response == 'N')
    #user-user mapping
    else
      puts 'Some Issue'
    end 

  end

  protected
  def set_interestID
    if user_signed_in? 
      session[:interest_id] = current_interestID
    end
  end
  def execute_sql_statement_direct(sql)
    results = ActiveRecord::Base.connection.execute(sql)
    if results.present?
        return results
    else
        return nil
    end
  end
end
