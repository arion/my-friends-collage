class HomeController < ApplicationController
  caches_page :friends

  def index
  end
  
  def friends
    @friends = User.find(params[:user_id]).friends.order("RAND()") if current_user
  end
  
  def refresh_frendlist
    if current_user
      begin
        current_user.reprocess_all_friendlists!
        expire_page "/javascripts/friends/#{current_user.id}/index.js"
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