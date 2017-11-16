Rails.application.routes.draw do

  root to: 'mood#index'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }

  resources :users
  get 'meet/:id', to: 'meet#index'

  post 'match/update', to:'match#updateResponse'

  resources :users do
    post 'notify', :on => :collection
  end
  resources :mood
  resources :match
  resources :meet

end
