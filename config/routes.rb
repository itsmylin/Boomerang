Rails.application.routes.draw do
   # get 'matches/listing'

  root to: 'visitors#mood'
  devise_for :users
  resources :users
end
