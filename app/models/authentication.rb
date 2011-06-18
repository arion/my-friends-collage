class Authentication < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user, :provider, :uid, :access_token, :auth_info
  
  attr_accessible :user_id, :provider, :uid, :access_token, :auth_info
  
  serialize :auth_info
  
  def self.find_or_new(user, auth)
    authentication = self.find_by_provider_and_uid(auth['provider'], auth['uid'])
    if authentication.blank?
      authentication = self.new(:provider => auth['provider'], :uid => auth['uid'])
      user ? authentication.user = user : authentication.build_user
    end
    authentication.access_token = auth['credentials']['token']
    authentication.auth_info = auth
    authentication
  end
end
