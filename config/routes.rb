Fidette::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  match '/mystatistics' => 'users#statistics', :via => 'get'

  resources :sessions
  resources :users

  root :to => 'home#index'

  resources :debts do
    member do
      put :solve
    end
  end

  resources :ideas do
    member do
      put :resolve
    end
  end

end
