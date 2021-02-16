Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: "signed_in" do
    resource :session, only: :destroy
    resources :tweets, only: [:new, :create, :destroy] do
      resources :replies, only: [:new, :create]
      resources :retweets, only: :create
    end
    resources :retweets, only: :destroy
    resources :users, only: [] do
      resources :subscriptions, only: :create
      resources :unsubscriptions, only: :create
    end
  end

  resources :sessions, only: [:new, :create]
  resources :tweets, only: :show
  resources :users, only: :show

  root to: "tweets#index"
end
