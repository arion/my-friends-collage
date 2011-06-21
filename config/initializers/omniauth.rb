Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'ZDedk6nO9FXPBVoGYQR2ew', 'AhindrpvX3UpcBPAUdfWLUdoklmP1zG9bX7KktUUbA'  
  provider :vkontakte, '2382537', 'Px86Bzydx0W5hbHdVDNG', :scope => 'friends'
  provider :facebook, '138849559523643', 'c334db621eecde651813a045b686ba2f', :scope => 'offline_access,read_friendlists'  
end