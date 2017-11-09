class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    puts params
    if !User.exists?(email: params[:user][:email])
      sign_up_params = sign_in_params.clone
      sign_up_params.store(:name, params[:user][:email].split('@')[0])
      sign_up_params.store(:password_confirmation, params[:user][:password])
      build_resource(sign_up_params)
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      super
    end
    @user = User.find_by email: params[:user][:email]
    @userData=UserUserMapping.find_by primeUserID: @user.id
    if @userData == nil
      @createUser = UserUserMapping.create(primeUserID: @user.id, timeslot: "", sent: "", received: "", completematch: "", nomatch: "")
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end
  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end
  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

end
