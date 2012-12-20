require 'sidekiq/web'

Kuiper::Application.routes.draw do
  mount Sidekiq::Web => '/queue'
  devise_for :users
  
  resources :sites do
    resources :pages do
      resources :visits
    end

    resources :visits
  end

  resources :visits

  resources :users do
    collection do
      get :current
    end
  end

  post "/pusher/auth" => "dashboard#auth"

  root to: "dashboard#show"
end
