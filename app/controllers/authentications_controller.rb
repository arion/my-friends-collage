class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    if authentication.blank?
      authentication = Authentication.new(:provider => auth['provider'], :uid => auth['uid'])
      current_user ? authentication.user = current_user : authentication.build_user
    end
    authentication.access_token = auth['credentials']['token']
    authentication.auth_info = auth
    if authentication.save
      session[:user_id] = authentication.user_id  
      flash[:notice] = "Успешно авторизовались на сервисе #{auth['provider']}"
      redirect_to root_path
    else
      flash[:error] = authentication.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end
  
  def destroy  
    session[:user_id] = nil  
    flash[:notice] = "Покинули систему"  
    redirect_to root_path
  end
  
  def failure
    flash[:notice] = "Во время авторизации произошла ошибка (#{params[:message]})"
    redirect_to root_path
  end

end