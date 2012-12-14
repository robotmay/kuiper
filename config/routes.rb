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

  root to: "dashboard#show"
end
