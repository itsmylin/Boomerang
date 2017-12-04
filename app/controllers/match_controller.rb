class MatchController < ApplicationController
  def index
    set_interestID
    if session[:interest_id] != nil && user_signed_in?
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).where.not(userID: current_user[:id]).order("RANDOM()").limit(3)
    elsif session[:interest_id] != nil && !user_signed_in?
      puts "i'm here"
      @userInterestMapping = UserInterestMapping.where(interestID: session[:interest_id]).order("RANDOM()").limit(1)
    else
      @userInterestMapping = UserInterestMapping.order("RANDOM()").limit(1)
    end
    @users = []
    if @userInterestMapping != nil
      if session[:interest_id] != nil && user_signed_in?
        @uumap = UserUserMapping.find_by_primeUserID(current_user[:id])
        @sentList =  @uumap["sent"].split(',')
        @completematchList = @uumap["completematch"].split(',')
        @nomatchList = @uumap["nomatch"].split(',')
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
  end

  def updateResponse
    @fromUser= params[:primuser]
    @toUser= params[:secuser]
    @interestID = params[:interestID]
    @existedID = params[:existedID]
    @response= params[:response]
    @presUserData = UserUserMapping.find_by primeUserID: @fromUser
    @secUserData = UserUserMapping.find_by primeUserID: @toUser
    @presUserNoMatchDataSet=@presUserData["nomatch"].split(',').to_set
    @presUserPrfctMatchDataSet=@presUserData["completematch"].split(',').to_set
    @presUserSentSet=@presUserData["sent"].split(',').to_set
    @presUserBeingLikedSet=@presUserData["received"].split(',').to_set
    if(@response == 'Y')
    #prim user is the logged in user whereas the sec user is the one abt whom the prim user is giving prefernce(yes/no)
    puts 'Inside response is Yes'
      if(@secUserData == nil)
        puts 'secUserData is nill'
      end

      @secUserReject=@secUserData["nomatch"].split(',')
      # puts 'list of users rejected by sec User '+ @secUserReject
      @secUserLiked=@secUserData["sent"].split(',')
      # puts 'list of users liked by sec user '+ @secUserLiked
      if(@secUserReject.include? @fromUser) #Already No from secUSer

          @presUserNoMatchDataSet=@presUserNoMatchDataSet.add @toUser #there is not diff btw who said no first ?? shu we handle this case too later?
          @presUserNoMatchData=@presUserNoMatchDataSet.to_a.join(',')
          puts 'presUserNoMatchData'+ @presUserNoMatchData
          UserUserMapping.where( primeUserID: @fromUser ).update_all( nomatch: @presUserNoMatchData )


      elsif(@secUserLiked.include? @fromUser) #Already Yes from secUser
        #remove
        #

        @presUserPrfctMatchDataSet=@presUserPrfctMatchDataSet.add @toUser
        @presUserPrfctMatchData=@presUserPrfctMatchDataSet.to_a.join(',')
        puts 'presUserPrfctMatchData'+ @presUserPrfctMatchData
        UserUserMapping.where( primeUserID: @fromUser ).update_all( completematch: @presUserPrfctMatchData )

        @secUserPrfctMatchDataSet=@secUserData["completematch"].split(',').to_set
        @secUserPrfctMatchDataSet=@secUserPrfctMatchDataSet.add @fromUser
        @secUserPrfctMatchData=@secUserPrfctMatchDataSet.to_a.join(',')
        puts 'secUserPrfctMatchData'+ @secUserPrfctMatchData
        UserUserMapping.where( primeUserID: @toUser ).update_all( completematch: @secUserPrfctMatchData )

      else


        @presUserSentSet=@presUserSentSet.add @toUser
        @presUserSent=@presUserSentSet.to_a.join(',')
        UserUserMapping.where( primeUserID: @fromUser ).update_all( sent: @presUserSent )

        @secUserRcvSet=@secUserData["received"].split(',').to_set
        @secUserRcvSet=@secUserRcvSet.add @fromUser
        @secUserRcv=@secUserRcvSet.to_a.join(',')
        UserUserMapping.where( primeUserID: @toUser ).update_all( received: @secUserRcv )
      end

    elsif(@response == 'N')
      #they both are mismatch !
      #updating the present user no match
      @presUserNoMatchDataSet= @presUserNoMatchDataSet.add @toUser
      @presUserNoMatchData=@presUserNoMatchDataSet.to_a.join(',')
      UserUserMapping.where( primeUserID: @fromUser ).update_all(nomatch: @presUserNoMatchData)

      #updating the secondary user no match
      @secUserNoMatchDataSet= (@secUserData["nomatch"]).split(',').to_set
      @secUserNoMatchDataSet= @secUserNoMatchDataSet.add @fromUser
      @secUserNoMatchData=@secUserNoMatchDataSet.to_a.join(',')
      UserUserMapping.where( primeUserID: @toUser ).update_all(nomatch: @secUserNoMatchData)

      @secUserLikedSet= @secUserData["sent"].split(',').to_set
      if(@secUserLikedSet.include? @fromUser)
          #removing from sec liked as prim has said no

          @secUserLikedSet.delete(@fromUser)
          @secUserLikedData=@secUserLikedSet.to_a.join(',')
          UserUserMapping.where( primeUserID: @toUser).update_all(sent: @secUserLikedData)



          @presUserBeingLikedSet.delete(@toUser)
          @presUserBeingLiked=@presUserBeingLikedSet.to_a.join(',')
          UserUserMapping.where( primeUserID: @fromUser).update_all(received: @presUserBeingLiked)

      end
    #user-user mapping
    else
     puts 'Some Issue'
    end
    @stop = true
    @user = []
    @map1 = []
    while @stop do
      UserInterestMapping.uncached do
        @userInterestMapping = UserInterestMapping.where(interestID: @interestID).where.not(userID: @fromUser).order("RANDOM()").first
      end
      break if @userInterestMapping == nil
      @map1 = @userInterestMapping
      unless @presUserSentSet.include?(@map1.userID) || @presUserNoMatchDataSet.include?(@map1.userID) || @presUserPrfctMatchDataSet.include?(@map1.userID) || @existedID.include?(@map1.userID)
        @user << User.find(@map1.userID)
      end     
      break if @user.length != 0
    end
    if @user != []
      if @user[0].avatar?
        @user << @user[0].avatar.url(:medium)
      end
      msg = { :status => "true", :message => "Success!", :data => @user }
    else
      msg = { :status => "false", :message => "No user found!", :data => @user }
    end
    respond_to do |format|
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
