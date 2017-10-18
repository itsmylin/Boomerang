class MatchController < ApplicationController
  def index
    puts current_user.id
    session.each do |k,v|
      puts k
      puts v
    end
    puts UserInterestMapping.find(16)
    
    if session[:interest_id] != nil
      @userInterestMappingList = UserInterestMapping.where(interestID: session[:interest_id])
    else
      @userInterestMappingList = UserInterestMapping.all
      puts "else"
    end
    #@userInterestMappingList = User.all
    @users = []
    # @userInterestMappingList.each do |map|
    #   @maps <<  { id: User.find(map.userID) , interest: Interest.find(map.interestID) }
    # end 
    @userInterestMappingList.each do |map|
      puts map.userID
      puts current_user.id
      unless  map.userID.to_i == current_user.id
        @users <<  User.find(map.userID)
        puts 'sssssssssssssss'
      end
    end 
    puts @users
    #puts @userInterestMappingList[0][:id]
    #puts @userInterestMappingList1[0][:userID]
  end

  def show
  end
end