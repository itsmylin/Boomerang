Rails.application.routes.draw do
   # get 'matches/listing'

  root to: 'visitors#index'
  get 'mood', to: 'visitors#mood'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users
end
