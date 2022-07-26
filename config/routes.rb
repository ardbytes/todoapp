Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "home/index"
  root "home#welcome"

  get "tasks/today"
  get "tasks/upcoming"
  resources :tasks do
    member do
      patch 'done'
    end
  end

  resources :tags do
    member do
      patch 'done'
    end
  end
end
