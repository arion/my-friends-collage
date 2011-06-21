class HomeController < ApplicationController
  caches_page :info
  caches_page :show

  def index
    @user = current_user
  end
  
  def show
    @user = User.find(params[:user_id])
  end
  
  def info
    @friends = User.find(params[:user_id]).friends.order(:uid)
  end
  
  def refresh_frendlist
    if current_user
      expire_page "/javascripts/users/#{current_user.id}/info.js"
      expire_page "/users/#{current_user.id}.html"
      begin
        current_user.reprocess_all_friendlists!
        redirect_to "/users/#{current_user.id}" and return
      rescue Exception => e
        flash[:error] = "Ошибка: #{e.message}"
      end
    else
      flash[:error] = 'Подключите хотя бы одну социальную сеть'
    end
    redirect_to root_path
  end

end