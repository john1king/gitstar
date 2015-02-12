class User < ActiveRecord::Base
  has_many :authorizations
  has_many :stars
  has_many :repos, through: :stars
  validates :name, :email, :presence => true

  def self.find_with_auth(auth_hash)
    Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]).try(:user)
  end

  def self.create_with_auth(auth_hash)
    user = new name: auth_hash["info"]["nickname"], email: auth_hash["info"]["email"]
    user.authorizations.build provider: auth_hash["provider"], uid: auth_hash["uid"]
    user.save!
    user
  end

  def star_repo(repo, pushed_at=DateTime.now)
      stars.create pushed_at: pushed_at
  end
end
