require 'net/http'
require "json"

class FriendList
  def initialize(auth)
    @auth = auth
    @user = @auth.user
  end
  
  def reprocess!
    self.send("reprocess_#{@auth.provider}!")
  end
  
  def reprocess_vkontakte!
    fields = %w(uid first_name last_name nickname sex bdate city country timezone photo photo_medium photo_big domain has_mobile rate contacts education)
    path = "/method/friends.get?uid=#{@auth.uid}&fields=#{fields.join(',')}&access_token=#{@auth.access_token}"
    
    json_result = get_response!("api.vkontakte.ru", path)
    return false if json_result['response'].blank?

    Friend.transaction do
      @user.friends.where(:provider => @auth.provider).delete_all
      json_result['response'].each do |friend|
        @user.friends.create!(:provider => @auth.provider, :uid => friend['uid'], 
          :name => [friend['first_name'], friend['nickname'], friend['last_name']].join(' '), 
          :other_info => friend, :photo_url => friend['photo']
        )
      end
    end
  end
  
  def reprocess_facebook!
    path = "/#{@auth.uid}/friends?access_token=#{@auth.access_token}"
    
    json_result = get_response!('graph.facebook.com', path)
    return false if json_result['data'].blank?
    
    Friend.transaction do
      @user.friends.where(:provider => @auth.provider).delete_all
      json_result['data'].each do |friend|
        @user.friends.create!(:provider => @auth.provider, :uid => friend['id'], 
          :name => friend['name'], :other_info => friend, 
          :photo_url => "http://graph.facebook.com/#{friend['id']}/picture?type=square"
        )
        # type can be: square (50x50), small (50 pixels wide, variable height), 
        # normal (100 pixels wide, variable height), and large (about 200 pixels wide, variable height)
      end
    end
  end
  
  def reprocess_twitter!
    path = "/1/statuses/friends.json?user_id=#{@auth.uid}&access_token=#{@auth.access_token}"
    
    json_result = get_response!('api.twitter.com', path)
    return false if json_result.blank?
    
    Friend.transaction do
      @user.friends.where(:provider => @auth.provider).delete_all
      json_result.each do |friend|
        @user.friends.create!(:provider => @auth.provider, :uid => friend['screen_name'], 
          :name => friend['name'], :other_info => friend, 
          :photo_url => friend['profile_image_url'].gsub('_normal', '_bigger')
        )
      end
    end
  end

private

  def get_response!(url, path)
    http = Net::HTTP.new(url,443)
    http.use_ssl = true
    response = http.get(path)
    json_result = JSON::parse(response.body)
    raise "Ошибка запроса (#{json_result.to_json})" if json_result.class == Hash && !json_result['error'].blank?
    json_result
  end

end