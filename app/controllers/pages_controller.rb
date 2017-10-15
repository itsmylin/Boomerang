class PagesController < ApplicationController
  before_filter :authenticate_user!
  
  def about
    @user == current_user
  end

end
