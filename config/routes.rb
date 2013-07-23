Fidette::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  resources :users
  resources :sessions

  root :to => 'home#index'

  resources :debts do
    member do
      put :solve
    end
  end

end
