Rails.application.routes.draw do

  resources :pdf_reporters

  mount RailsSettingsUi::Engine, at: 'settings'
  resources :reporters do
    member do
      post :send_mail
    end
  end

  resources :budgets do
    post :preview, on: :collection
    get :new_with_parameter, on: :collection
    get :all_budgets, on: :collection
  end

  controller :budgets do
    get 'budget/summary/:title' => :summary
  end

  resources :donations

  get 'receipts/all'
  get 'set_language/english'
  get 'set_language/german'


  resources :members do
    member do
      post :send_mail
      get :budgets
    end

    collection do
      get :info
      get :chart_wassiyyat_data
      get :chart_monthly_proceeding
      get :get_all_members
      post :import
      get :import_page
    end

    resources :incomes
    resources :receipts
  end

  root to: 'visitors#index'
  devise_for :users, path_names: {sign_up: 'cmon_let_me_in', sign_in: 'login'}
  resources :users
end
