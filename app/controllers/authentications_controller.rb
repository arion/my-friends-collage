class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    authentication = Authentication.find_or_new(current_user, auth)
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
    @current_user, session[:user_id] = nil
    flash[:notice] = "Покинули систему"  
    redirect_to root_path
  end
  
  def failure
    flash[:notice] = "Во время авторизации произошла ошибка (#{params[:message]})"
    redirect_to root_path
  end

end