class Friend < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user, :uid, :name, :provider, :photo_url, :other_info
  attr_accessible :user_id, :provider, :uid, :name, :other_info, :photo_url
  
  serialize :other_info
  
  SOCIAL_USER_LINKS = {
    'twitter' => 'https://twitter.com/%s',
    'vkontakte' => 'http://vkontakte.ru/id%s',
    'facebook' => 'http://www.facebook.com/profile.php?id=%s'
  }
  
  def link_on_profile
    SOCIAL_USER_LINKS[self.provider] % self.uid
  end
end
