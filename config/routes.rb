Rails.application.routes.draw do
  root "photos#index"
  
  devise_for :users

  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos

  #alternative
  # resources :users, only: :show

  get ":username/liked" => "users#liked", as: :liked
  get ":username/feed" => "users#feed", as: :feed
  get ":username/followers" => "users#followers", as: :followers
  get ":username/following" => "user#following", as: :following

  get "/:username" => "users#show", as: :user

end
