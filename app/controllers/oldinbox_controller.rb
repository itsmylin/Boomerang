class OldinboxController < ApplicationController
	def index
			if params[:id]!=nil
        @sqlQuery='select * from user_user_mappings where id ='+params[:id];
        puts @sqlQuery
				@inboxMsgs = execute_sql_statement_direct(@sqlQuery)


				@inboxMsgs.each do |mssg|
            puts 'I am here 2'
        end
			end

				#Ali was here -- simple code to just have an inbox page
				if session[:interest_id] != nil
					@fakeuserInterestMappingList = UserInterestMapping.where(interestID: session[:interest_id])
				else
					@fakeuserInterestMappingList = UserInterestMapping.all
				end
				@fakeusers = []
				@fakeuserInterestMappingList.each do |fakemap|
					if user_signed_in?
						unless  fakemap.userID.to_i == current_user.id
						 @fakeusers <<  User.find(fakemap.userID)
						end
					else
						@fakeusers <<  User.find(fakemap.userID)
					end
				end
	end

    def updateResponse()
        @fromUser=params[:primuser];
        @toUser=params[:secuser];
        @response=params[ :response];
        @presUserData=UserUserMapping.find_by primeUserID: @fromUser
        @secUserData=UserUserMapping.find_by primeUserID: @toUser

        if(@response=='Y')
        #prim user is the logged in user whereas the sec user is the one abt whom the prim user is giving prefernce(yes/no)
        @secUserReject=(secUserData["nomatch"]).split(',')
        puts 'list of users rejected by sec User '+ @secUserReject
        @secUserLiked=(secUserData["sent"]).split(',')
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
				puts '@response == \'N\''
       else
         puts 'Some Issue'
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
