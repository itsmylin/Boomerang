class ApplicationController < ActionController::Base
  #protect_from_forgery with: :null_session #exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  private
  # function for define current_interestID for the everytime loading webpage
  def current_interestID
    if current_user == nil
      @current_interestID = nil
    elsif UserInterestMapping.where(userID: current_user[:id]) == []
      @current_interestID = nil
    else
      @current_interestID = UserInterestMapping.where(userID: current_user[:id])[0][:interestID]
    end
    @current_interestID
  end
  def configure_permitted_parameters
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    #devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :is_female, :date_of_birth, :avatar) }

  end

end
