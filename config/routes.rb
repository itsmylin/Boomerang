Rails.application.routes.draw do
  get 'static_pages/listing'

  get 'static_pages/interest'

  root to: 'visitors#index'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users
end
