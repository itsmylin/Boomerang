Rails.application.routes.draw do
   # get 'matches/listing'

  root to: 'mood#index'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users do
    get 'notify', :on => :collection
  end
  resources :mood
  resources :match
end
