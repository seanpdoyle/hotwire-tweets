Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tweets, only: [:show, :new, :create, :destroy]
  resources :users, only: :show

  root to: "tweets#index"
end
