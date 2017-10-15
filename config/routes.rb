Rails.application.routes.draw do
  get 'static_pages/listing'

  get 'static_pages/interest'

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
