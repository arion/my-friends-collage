class Authentication < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user, :provider, :uid, :access_token, :auth_info
  
  attr_accessible :user_id, :provider, :uid, :access_token, :auth_info
  
  serialize :auth_info
end
