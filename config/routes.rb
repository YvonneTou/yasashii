Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/dashboard", to: "dashboards#show", as: :dashboard

  resources :clinics, only: [:index, :show] do
    resources :reviews
  end

  resources :connections, except: [:delete] do
    resources :messages, only: [:show, :new, :create]
  end
end
