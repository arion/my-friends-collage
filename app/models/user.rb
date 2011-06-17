class User < ActiveRecord::Base
  has_many :authentications
  
  def connect_to?(provider)
    self.authentications.find_by_provider(provider)
  end
end
