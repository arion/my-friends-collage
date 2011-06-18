class HomeController < ApplicationController
  caches_page :info

  def index
  end
  
  def info
    @user = User.find(params[:user_id])
    @friends = @user.friends.order("RAND()")
    @authentications = @user.authentications.fresh
  end
  
  def refresh_frendlist
    if current_user
      expire_page "/javascripts/users/#{current_user.id}/info.js"
      begin
        current_user.reprocess_all_friendlists!
        flash[:notice] = 'Успешно обновили список ваших друзей'
      rescue Exception => e
        flash[:error] = "Ошибка: #{e.message}"
      end
    else
      flash[:error] = 'Подключите хотя бы одну социальную сеть'
    end
    redirect_to root_path
  end

end