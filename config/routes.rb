Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :negotiations
  get "/index_negotiations", to: "negotiations#index_negotiations"


  resources :proposals


  get "/signup", to: "users#signup_page"
  post "/signup", to: "users#signup"

  get "/login", to: "users#login_page"
  post "/login", to: "users#login"

  delete "/logout", to: "users#logout"

  get "/settings", to: "users#settings"
  post "/settings", to: "users#settings_save"

  get 'districts/:id/talukas', to: 'users#talukas'
end
