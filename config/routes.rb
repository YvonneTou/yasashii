Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :clinics do
    resources :phone_calls
    resources :reviews
  end
  resources :phone_calls do
    resources :messages
  end

  get "/dashboard", to: "dashboard#show"
end
