MyFriendsCollage::Application.routes.draw do
  resources :authentications

  match "/" => "home#index"
  match '/users/:user_id' => "home#show"
  
  match "/javascripts/users/:user_id/info" => "home#info"
  match "/refresh_frendlist" => "home#refresh_frendlist"
  
  match "/auth/:provider/callback" => "authentications#create"
  match "/auth/failure" => "authentications#failure"
  match "/signout" => "authentications#destroy", :as => :signout 

  root :to => "home#index"
end
