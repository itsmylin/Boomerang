class VisitorsController < ApplicationController
  def index
    if user_signed_in?
        redirect_to static_pages_listing_path
    end
  end
end
