class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    if authentication.blank?
      authentication = Authentication.new(:provider => auth['provider'], :uid => auth['uid'])
      current_user ? authentication.user = current_user : authentication.build_user
    end
    if authentication.save
      session[:user_id] = authentication.user_id  
      redirect_to root_url, :notice => "Successfully created authentication."
    else
      redirect_to root_url, :error => authentication.full_messages.to_sentence
    end
  end
  
  def destroy  
    session[:user_id] = nil  
    redirect_to root_url, :notice => "Signed out!"  
  end
  
  def failure
    redirect_to root_url, :notice => "Unknown error (#{params[:message]})"
  end

end