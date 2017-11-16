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
  def updateResponse
    puts 'I am inside update Response'
    @fromUser=params[:primuser]
    @toUser=params[:secuser]
    @interestID = params[:interestID]
    @existedID = params[:existedID]
    @response=params[ :response]
    @presUserData=UserUserMapping.find_by primeUserID: @fromUser
    @secUserData=UserUserMapping.find_by primeUserID: @toUser

    puts @presUserData.inspect
    puts @secUserData.inspect
    # if @presUserData == nil
    #     @preUserData = UserUserMapping.create(primeUserID: @fromUser, timeslot: '', sent: '', received: '', completematch: '', nomatch: '')
    # end
    # if @secUserdData == nil
    #     @secUserData = UserUserMapping.create(primeUserID: @toUser, timeslot: '', sent: '', received: '', completematch: '', nomatch: '')
    # end

    #puts 'I am printing all the incoeming values'
    #puts @fromUser
    #puts @toUser
    #puts @response

    if(@response=='Y')
    #prim user is the logged in user whereas the sec user is the one abt whom the prim user is giving prefernce(yes/no)
    puts 'Inside response is Yes'
        if(@secUserData==nil)
            puts 'secUserData is nill'
        end


    @secUserReject=(@secUserData["nomatch"]).split(',')
   # puts 'list of users rejected by sec User '+ @secUserReject
    @secUserLiked=(@secUserData["sent"]).split(',')
   # puts 'list of users liked by sec user '+ @secUserLiked
        if(@secUserReject.include? @fromUser) #Already No from secUSer
            @presUserNoMatchDataArr=(@presUserData["nomatch"]).split(',')
            @presUserNoMatchDataArr=@presUserNoMatchDataArr.push(@toUser) #there is not diff btw who said no first ?? shu we handle this case too later?
            @presUserNoMatchData=@presUserNoMatchDataArr.join(',')
            puts 'presUserNoMatchData'+ @presUserNoMatchData
            UserUserMapping.where( primeUserID: @fromUser ).update_all( nomatch: @presUserNoMatchData )


        elsif(@secUserLiked.include? @fromUser) #Already Yes from secUser
                #remove
                #
                @presUserPrfctMatchDataArr=(@presUserData["completematch"]).split(',')
                @presUserPrfctMatchDataArr=@presUserPrfctMatchDataArr.push(@toUser)
                @presUserPrfctMatchData=@presUserPrfctMatchDataArr.join(',')
                puts 'presUserPrfctMatchData'+ @presUserPrfctMatchData
                UserUserMapping.where( primeUserID: @fromUser ).update_all( completematch: @presUserPrfctMatchData )

                @secUserPrfctMatchDataArr=(@secUserData["completematch"]).split(',')
                @secUserPrfctMatchDataArr=@secUserPrfctMatchDataArr.push(@fromUser)
                @secUserPrfctMatchData=@secUserPrfctMatchDataArr.join(',')
                puts 'secUserPrfctMatchData'+ @secUserPrfctMatchData
                UserUserMapping.where( primeUserID: @toUser ).update_all( completematch: @secUserPrfctMatchData )




        else

            @presUserSentArr=(@presUserData["sent"]).split(',')
            @presUserSentArr=@presUserSentArr.push(@toUser)
            @presUserSent=@presUserSentArr.join(',')
            UserUserMapping.where( primeUserID: @fromUser ).update_all( sent: @presUserSent )


            @secUserRcvArr=(@secUserData["received"]).split(',')
            @secUserRcvArr=@secUserRcvArr.push(@fromUser)
            @secUserRcv=@secUserRcvArr.join(',')
            UserUserMapping.where( primeUserID: @toUser ).update_all( received: @secUserRcv )
        end

    elsif(@response == 'N')
        #they both are mismatch !
        #updating the present user no match
        @primUserNoMatchDataArr= (@presUserData["nomatch"]).split(',')
        @primUserNoMatchDataArr= @primUserNoMatchDataArr.push(@toUser)
        @primUserNoMatchData=@primUserNoMatchDataArr.join(',')
        UserUserMapping.where( primeUserID: @fromUser ).update_all(nomatch: @primUserNoMatchData)

        #updating the secondary user no match
        @secUserNoMatchDataArr= (@secUserData["nomatch"]).split(',')
        @secUserNoMatchDataArr= @secUserNoMatchDataArr.push(@fromUser)
        @secUserNoMatchData=@secUserNoMatchDataArr.join(',')
        UserUserMapping.where( primeUserID: @toUser ).update_all(nomatch: @secUserNoMatchData)

        @secUserLikedArr=(@secUserData["sent"].split(','))
        if(@secUserLikedArr.include? @fromUser)
            #removing from sec liked as prim has said no

            @secUserLikedArr=@secUserLikedArr-[@fromUser]
            @secUserLikedData=@secUserLikedArr.join(',')
            UserUserMapping.where( primeUserID: @toUser).update_all(sent: @secUserLikedData)


            @primUserBeingLikedArr=(@presUserData["received"]).split(',')
            @primUserBeingLikedArr=@primUserBeingLikedArr-[@toUser]
            @primUserBeingLiked=@primUserBeingLikedArr.join(',')
            UserUserMapping.where( primeUserID: @fromUser).update_all(received: @primUserBeingLiked)

        end
    #user-user mapping
    else
     puts 'Some Issue'
    end
    @userInterestMapping = UserInterestMapping.where(interestID: @interestID).where.not(userID: @fromUser).order("RANDOM()")
    @user = []
    if @userInterestMapping != nil
        @uumap = UserUserMapping.find_by_primeUserID(@fromUser)
        @sentList = @uumap["sent"].split(',')
        @completematchList = @uumap["completematch"].split(',')
        @nomatchList = @uumap["nomatch"].split(',')
        @userInterestMapping.each do |map|
            unless @sentList.include?(map.userID) || @nomatchList.include?(map.userID) || @completematchList.include?(map.userID) || @existedID.include?(map.userID)
                @user << User.find(map.userID)
            end
            break if @user.length == 1
        end
    end
    puts @user.inspect

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
