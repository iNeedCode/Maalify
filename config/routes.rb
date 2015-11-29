Rails.application.routes.draw do

  resources :budgets do
    post :preview, on: :collection
    get :new_with_parameter, on: :collection
    get :all_budgets, on: :collection
  end


  resources :donations

  get 'receipts/all'
  get 'set_language/english'
  get 'set_language/german'


  resources :members do
    get :import_page, on: :collection
    collection { post :import }
    resources :incomes
    resources :receipts
  end

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
