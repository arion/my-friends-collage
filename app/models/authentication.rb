class Authentication < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user, :provider, :uid, :access_token, :auth_info
  validates_uniqueness_of :uid, :scope => :provider
  
  attr_accessible :user_id, :provider, :uid, :access_token, :auth_info
  
  # default_scope ->() { where('updated_at > ', 5.minutes.ago) }
  
  serialize :auth_info
  
  before_update :touch_date
  
  scope :fresh, where('updated_at > ?', 5.hour.ago)
  
  def self.find_or_new(user, auth)
    authentication = self.find_by_provider_and_uid(auth['provider'].to_s, auth['uid'].to_s)
    if authentication.blank?
      authentication = self.new(:provider => auth['provider'].to_s, :uid => auth['uid'].to_s)
      user ? authentication.user = user : authentication.build_user
    end
    authentication.access_token = auth['credentials']['token']
    authentication.auth_info = auth
    authentication
  end

private

  # FIXME: wtf? why timestamp don't touched
  def touch_date
    self.updated_at = Time.now
  end
end
