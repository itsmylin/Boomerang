require 'json'

class MeetController < ApplicationController
	def index
        puts 'I am telling you the id'
        puts params[:id]
		if params[:id]!=nil
            puts 'Are v ready to get data '
            @inboxMsgs=UserUserMapping.find_by primeUserID: params[:id]
            #puts @sqlQuery
    		#@inboxMsgs = execute_sql_statement_direct(@sqlQuery)
    		#@inboxMsgs.each do |mssg|
            #puts 'I am populating my json with the values'
            #puts @inboxMsgs.inspect
            @presUserReceivedInbox=(@inboxMsgs["received"]).split(',')
            @presUserCompleteMatch=(@inboxMsgs["completematch"]).split(',')
            puts @presUserReceivedInbox
            puts @presUserCompleteMatch
            json_response = '{"entries":[{"personid":"Dummy","type":"match"}]}'
            hash_response = JSON.parse(json_response)
            @presUserReceivedInbox.each do |rcvd_val|
                hash_response['entries'].push({"personid"=>rcvd_val,"type"=>'rcvd'})
                
            end
            @presUserCompleteMatch.each do |match_val|
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

    
	def execute_sql_statement_direct(sql)
        results = ActiveRecord::Base.connection.execute(sql)
        if results.present?
            return results
        else
            return nil
        end
    end
end
