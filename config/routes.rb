Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
    resources :testimonials, only: [:index] do
      member do
        patch :approve
      end
    end
  end
  
  # devise_for :admins

  # devise_for :admins, controllers: {
  # sessions: 'admins/sessions',
  # registrations: 'admins/registrations',
  # passwords: 'admins/passwords'
  # }

  devise_for :admins, skip: [:registrations], controllers: {
  sessions: 'admins/sessions',
  passwords: 'admins/passwords'
  }


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  authenticated :admin do # Corrected: use :admin instead of :admin_user
    root to: "admin#index", as: :admin_root
  end

  root to: "home#index"

  # get "admin" => "admin#index"

  resources :categories, only: [ :show ]
  resources :products, only: [ :show ]
  get "about" => "pages#about"
  get "cart" => "carts#show"
  # post "checkout" => "checkout#create"

  post "/checkout", to: "checkouts#create"
  # Define success and cancel routes for Stripe redirect
  get "/checkout/success", to: "checkouts#success", as: :success_checkout
  get "/checkout/cancel", to: "checkouts#cancel", as: :cancel_checkout

  post "/webhooks/stripe", to: "webhooks#stripe"

  resources :orders, only: [:index, :show] do
    member do
      get :receipt
    end
  end

  # Public routes for testimonials (new and create)
  resources :testimonials, only: [:new, :create]

  
  # Keep this route so Stripe redirects here
  # get "/checkout/success", to: "checkouts#success"
  


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
