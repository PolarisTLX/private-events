Rails.application.routes.draw do

  # get 'static_pages/about'
  # get 'static_pages/contact'
  get     '/about',   to: 'static_pages#about'
  get     '/contact', to: 'static_pages#contact'
  root    'sessions#new'
  get     'sessions/new'
  get     '/signup',  to: 'users#new'
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  resources :users, only: [:new, :create, :show, :edit, :update, :index]
  resources :users do
    resources :invites, only: [:new, :create]
  end

  resources :events
  resources :events do
    resources :invites, only: [:new, :create]
  end

  resources :invites, only: [:update]

end
