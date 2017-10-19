class InboxController < ApplicationController
	def index
		@inboxMsgs = execute_sql_statement_direct('select * from user_user_mappings')
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
