class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  def listing
  end

  def interest
  	@interestList=Interest.all
  end
end
