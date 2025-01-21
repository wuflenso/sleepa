Rails.application.routes.draw do
  resources :sleeps
  resources :followers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "rails/health#show"

  scope "/api/v1" do
    resources :users

    resources :followers, path: "followers", only: [ :index ] do
      get  "/details" => "followers#show", on: :collection
      get  "/followings" => "followers#followings", on: :collection
      post "/follow" => "followers#create", on: :collection
      delete "/unfollow" => "followers#delete", on: :collection
    end

    resources :followers, path: "sleeps", only: [ :index, :show, :create ] do
      get "/followings" => "sleeps#followings", on: :collection
      delete "/delete" => "sleeps#delete", on: :member
    end
  end
end
