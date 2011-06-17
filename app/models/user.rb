class User < ActiveRecord::Base
  has_many :authentications
  has_many :friends
  
  def connect_to?(provider)
    self.authentications.find_by_provider(provider)
  end
  
  def reprocess_all_friendlists!
    if self.created_at == self.updated_at || self.updated_at > 5.minutes.ago
      raise 'вы слишком часто пытаетесь обновлять список друзей, разрешено только раз в 5 минут'
    end
    self.authentications.each do |auth|
      fl = FriendList.new(auth)
      fl.reprocess!
    end
    self.touch
  end
end
