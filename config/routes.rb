Rails.application.routes.draw do
  # Health check (keep this)
  get "up" => "rails/health#show", as: :rails_health_check

  # --- Authentication ---
  get    "signup", to: "users#new"
  post   "signup", to: "users#create"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # --- Public / customer pages ---
  root "home#index"
  get "/home", to: "home#index", as: :customer_home
  # resources :reservations

  # --- Admin namespace ---
  namespace :admin do
    get "dashboard", to: "dashboard#index", as: :dashboard

    # resources :users
    # resources :reservations
  end
end
