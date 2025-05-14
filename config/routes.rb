Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  
  
  resources :negotiations, except: %i[new show edit]
  get "/index_negotiations", to: "negotiations#index_negotiations"

  resources :proposals, except: %i[new show edit]

  post "/signup", to: "users#signup"
  post "/login", to: "users#login"
  delete "/logout", to: "users#logout"


  get 'districts/:id/talukas', to: 'users#talukas'
end

