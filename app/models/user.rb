class User < ActiveRecord::Base
  has_many :authentications
  has_many :friends
  
  def connect_to?(provider)
    self.authentications.find_by_provider(provider)
  end
  
  def reprocess_all_friendlists!
    if self.friends.count > 0 && self.updated_at > 5.minutes.ago #&& false # uncomment if remove limits
      raise 'вы слишком часто пытаетесь обновлять список друзей, разрешено только раз в 5 минут'
    end
    self.authentications.fresh.each do |auth|
      fl = FriendList.new(auth)
      fl.reprocess!
    end
    self.touch
  end
  
  def create_png!(path_to_png)
    photos = self.friends.collect(&:photo_url).join(' ')
    # TODO: make copyrate_block
    copyrate_block = 'path-to-copyrate-block'
    `montage #{photos} #{copyrate_block} geometry 50x50+2+2 #{path_to_png}`
  end
end
