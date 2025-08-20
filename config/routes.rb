Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  resources :items
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "/items/:id/flip", to: "items#flip", as: "flip_item"

  get "up" => "rails/health#show", as: :rails_health_check

  root "items#index"
end
