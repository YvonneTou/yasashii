Rails.application.routes.draw do
  get 'about/show'
  devise_for :users
  root to: "pages#home"

  get "/dashboard", to: "dashboards#show", as: :dashboard
  get "/about", to: "about#show", as: :about

  resources :clinics, only: [:index, :show] do
    resources :reviews
  end

  resources :connections, except: [:delete] do
    resources :messages, only: [:show, :new, :create]
  end

  get '/answer', to: "voice#answer"
  post '/event', to: "voice#event"
end
