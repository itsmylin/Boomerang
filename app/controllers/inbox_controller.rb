class InboxController < ApplicationController
	def index
		@inboxMsgs = execute_sql_statement_direct('select * from user_user_mappings')
        @inboxMsgs.each do |mssg|
            puts 'I am here 2'
            end
	end
    
    def updateResponse()
        @fromUser=params[:primuser];
        @toUser=params[:secuser];
        @response=params[ :response];

       if(@response=='Y')
        #user-user mapping
        @presUserData=UserUserMapping.find_by primeUserID: @fromUser
        @presUserSent=presUserData["sent"]
        @presUserSent=@presUserSent+","+@toUse
        UserUserMapping.where( primeUserID: @fromUser ).update_all( sent: @presUserSent )

        @secUserData=UserUserMapping.find_by secUserID: @toUser
        @secUserRcv=secUserData["received"]
        @secUserRcv=@secUserRcv+","+@fromUser
        UserUserMapping.where( primeUserID: @toUser ).update_all( received: @secUserRcv )

       elsif(@response == 'N')
        #user-user mapping
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
