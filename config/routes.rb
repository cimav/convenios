Rails.application.routes.draw do

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  #get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  #get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  #resources :agreements do
  #  member do
  #    patch :validate
  #    patch :return_for_review
  #  end
  #end

  resources :agreements do
    resources :members, only: [:index, :new, :create, :destroy, :show, :edit]
    member do
      post :upload_document
      post :update_status
    end
    resources :agreement_logs, only: [:index, :create]
  end
  resources :documents, only: [:destroy]
  resources :clients
  resources :users

  #resources :agreements
  resources :agreement_types

  #root "agreements#index"

  root 'home#index'
  #root "sessions#new"

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  #get '/logout', to: 'sessions#destroy'
  #get '/login' => 'sessions#login'

  #get '/auth/:provider/callback' => 'sessions#create'
  #get '/auth/failure' => 'sessions#failure'
  #get '/logout' => 'sessions#destroy'

  get '/login', to: 'sessions#new', as: :login
  #delete '/logout', to: 'sessions#destroy', as: :logout
  get '/logout', to: 'sessions#destroy', as: :logout

  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get 'dashboard/:id', to: 'dashboard#show', as: :dashboard_show

  namespace :api do
    post "proxy_x_oauth2", to: "proxy_mailer#re_send"
  end

end
