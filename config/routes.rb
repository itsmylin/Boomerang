Rails.application.routes.draw do

  root to: 'mood#index'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }

  resources :users
  get 'match/:id', to: 'match#index'

  post 'matchUpdate', to:'match#updateResponse'

  resources :users do
    post 'notify', :on => :collection
  end
  resources :mood
  resources :meet
  resources :match
  
end
