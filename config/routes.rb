MyFriendsColage::Application.routes.draw do
  resources :authentications

  get "home/index"
  
  match "/auth/:provider/callback" => "authentications#create"
  match "/auth/failure" => "authentications#failure"
  match "/signout" => "authentications#destroy", :as => :signout 

  root :to => "home#index"
end
