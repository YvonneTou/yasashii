Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/dashboard", to: "dashboard#dashboard", as: :dashboard

  resources :clinics, only: [:index, :show] do
    resources :reviews
  end

  resources :connections, except: [:delete] do
    resources :messages, only: [:show, :new, :create]
  end

  get '/answer', to: 'ivr#answer'
  post '/event', to: 'ivr#event'
  get '/voice', to: 'voice#trigger_call'
end
