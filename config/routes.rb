Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/dashboard", to: "dashboard#dashboard", as: :dashboard

  resources :clinics do
    resources :phone_calls
    resources :reviews
  end
  resources :phone_calls do
    resources :messages, only: :create
  end
end
