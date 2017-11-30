require 'json'

class MeetController < ApplicationController
	def index
        puts 'I am telling you the id'
        #puts params[:id]
        puts current_user[:id]
		if current_user[:id]!=nil
            puts 'Are v ready to get data '
            @inboxMsgs=UserUserMapping.find_by primeUserID: current_user[:id]
            #puts @sqlQuery
    		#@inboxMsgs = execute_sql_statement_direct(@sqlQuery)
    		#@inboxMsgs.each do |mssg|
            #puts 'I am populating my json with the values'
            #puts @inboxMsgs.inspect
            @presUserReceivedInbox=(@inboxMsgs["received"]).split(',')
            @presUserCompleteMatch=(@inboxMsgs["completematch"]).split(',')
            #@presUserReceivedInbox=UserUserMapping.select('received').find_by primeUserID: params[:id].split(',')
            #@presUserCompleteMatch=UserUserMapping.select('completematch').find_by primeUserID: params[:id].split(',')
            #puts @presUserReceivedInbox
            #puts @presUserCompleteMatch

            @totalItems=@presUserReceivedInbox.length + @presUserCompleteMatch.length

            puts @totalItems

            @totalpages= (@totalItems/10)+1;
            puts 'Total pages'
            puts @totalpages

            json_response = '{"entries":[{"personid":"Dummy","type":"match"}]}'
            hash_response = JSON.parse(json_response)
            @presUserReceivedInbox.first(10).each do |rcvd_val|
                hash_response['entries'].push({"personid"=>rcvd_val,"type"=>'rcvd'})
                
            end
            @presUserCompleteMatch.first(10).each do |match_val|
                hash_response['entries'].push({"personid"=>match_val,"type"=>'match'})
                
            end
            puts hash_response.inspect
            @matchedUsers = hash_response['entries']
            #end
		end

		#puts 'Ishani Fake User?'
           # @sqlQuery='select * from user_user_mappings where id = 1';
           # puts @sqlQuery
            #@inboxMsgs = execute_sql_statement_direct(@sqlQuery)
            #@inboxMsgs.each do |mssg|
           # puts 'I am populating my json with the values'
            #json_response = '{"entries":[{"personid":"User_1","type":"match"},{"personid":"User_2","type":"rcvd"}]}'
            #hash_response = JSON.parse(json_response)
            #@matchedUsers = hash_response['entries']
	end

    def updateResponse
        puts 'I am inside update Response'
        @fromUser=params[:primuser];
        @toUser=params[:secuser];
        @interestID = params[:interestID]
        @response=params[ :response];
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
                unless @sentList.include?(map.userID) || @nomatchList.include?(map.userID) || @completematchList.include?(map.userID)
                    @user << User.find(map.userID)
                end
                break if @user.length == 1
            end
        end
        puts @user.inspect
        if @user != []
            msg = { :status => "true", :message => "Success!", :data => @user }
        else
            msg = { :status => "false", :message => "No user found!", :data => @user }
        end
        respond_to do |format|
            format.json  { render :json => msg } # don't do msg.to_json
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
