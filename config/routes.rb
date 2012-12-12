require 'sidekiq/web'

Castle::Application.routes.draw do
  mount Sidekiq::Web => '/queue'
  devise_for :users

  root to: "pages#home"
end
