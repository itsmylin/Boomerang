class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    puts @users[1][:name]
  end

  def show
    @user = User.find(params[:id])
    #unless @user == current_user
    #  redirect_to :back, :alert => "Access denied."
    #end
  end

  def notify
    redirect_to :back
  end

end
