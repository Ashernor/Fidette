Fidette::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  resources :statistics, :only => [:appstatistics]
  resources :sessions
  resources :users

  match '/mystatistics' => 'users#statistics', :via => 'get'
  match '/appstatistics' => 'statistics#appstatistics', :via => 'get'

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
