Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root 'static_pages#home'
  get 'static_pages/home'
  # get 'static_pages/help'
  # get 'static_pages/about'
  # get  'static_pages/contact'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do #=> /users/:id/ ...(この中に好きなの入れられる)
      get :following, :followers #=> GET /users/1/following  ==> following action
    end
  end
  
  resources :users
  resources :account_activations, only: [:edit] 
  # (ユーザから) GET /account_activations/:id/edit
  # params[:id] <== 有効化トークン入れる
  # Controller: params[:id]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'application#hello'
end
