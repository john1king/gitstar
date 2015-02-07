class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :access_token, :presence => true
end
