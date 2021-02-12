Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: "signed_in" do
    resource :session, only: :destroy
    resources :tweets, only: [:new, :create, :destroy]
  end

  resources :sessions, only: [:new, :create]
  resources :tweets, only: :show
  resources :users, only: :show

  root to: "tweets#index"
end
