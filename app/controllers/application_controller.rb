class ApplicationController < ActionController::Base
  protect_from_forgery

private

def check_authenticate
  redirect_to root_url, :error => "Don't have permissions" unless current_user
end

def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end
helper_method :current_user

end
