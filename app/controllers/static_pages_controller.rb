class StaticPagesController < ApplicationController
  def listing
  end

  def interest
  	@interestList=Interest.all
  end
end
