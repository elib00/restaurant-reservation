Rails.application.routes.draw do
  # --- Health check ---
  get "up" => "rails/health#show", as: :rails_health_check

  # --- Authentication ---
  get    "signup", to: "users#new"
  post   "signup", to: "users#create"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # --- Public landing page ---
  root "home#index"
  get "/home", to: "home#index", as: :customer_home

  # --- Customer reservations ---
  resources :reservations, only: [:index, :new, :create, :destroy] do
    collection do
      get :calendar  # Customer calendar view
    end
    get :confirmation, on: :member
  end

  # --- Admin namespace ---
  namespace :admin, constraints: AdminConstraint  do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index", as: :dashboard

    resources :reservations, only: [:index, :edit, :update, :destroy] do
      collection do
        get :calendar  # Admin calendar view
      end
    end
    
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :time_slots, except: [:show]  
    resources :tables, only: [:index, :new, :create, :edit, :update, :destroy]
  end
end
