Rails.application.routes.draw do
  

  get 'set_language/english'

  get 'set_language/german'

  resources :members

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
