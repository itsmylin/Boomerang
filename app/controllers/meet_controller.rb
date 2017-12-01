require 'json'

class MeetController < ApplicationController
	def index
        puts 'I am telling you the id of param(this id for new feature pagination and not user) as well as user'
        puts params[:pgid]
        puts '######################'
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

            
            if params[:pgid]==nil || params[:pgid] == "pg1"
                @presUserReceivedInbox[0,10].each do |rcvd_val|
                    hash_response['entries'].push({"personid"=>rcvd_val,"type"=>'rcvd'})
                    
                end
                @presUserCompleteMatch[0,10].each do |match_val|
                    hash_response['entries'].push({"personid"=>match_val,"type"=>'match'})
                    
                end
                puts hash_response.inspect
                @matchedUsers = hash_response['entries']
            else
                @askedPage=params[:pgid].split("pg")[1]
                puts 'The asked page number is.........'
                puts @askedPage
                @strPoint= (10*(@askedPage.to_i-1))+1
                @presUserReceivedInbox[@strPoint,10].each do |rcvd_val|
                    hash_response['entries'].push({"personid"=>rcvd_val,"type"=>'rcvd'})
                    
                end
                @presUserCompleteMatch[0,10].each do |match_val|
                    hash_response['entries'].push({"personid"=>match_val,"type"=>'match'})
                    
                end
                puts hash_response.inspect
                @matchedUsers = hash_response['entries']
            end
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

    
	def execute_sql_statement_direct(sql)
        results = ActiveRecord::Base.connection.execute(sql)
        if results.present?
            return results
        else
            return nil
        end
    end
end
