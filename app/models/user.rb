class User < ActiveRecord::Base
  has_many :authorizations
  validates :name, :email, :presence => true

  def self.find_with_auth(auth_hash)
    Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]).try(:user)
  end

  def self.create_with_auth(auth_hash)
    user = new name: auth_hash["info"]["nickname"], email: auth_hash["info"]["email"]
    user.authorizations.build provider: auth_hash["provider"], uid: auth_hash["uid"], access_token: auth_hash["credentials"]["token"]
    user.save!
    user
  end
end
