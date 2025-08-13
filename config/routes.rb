Rails.application.routes.draw do
  resources :items
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check

  root "items#index"
end
