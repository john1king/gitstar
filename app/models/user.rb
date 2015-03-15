class User < ActiveRecord::Base
  has_many :authorizations
  has_many :stars, -> { where(active: true).order(starred_at: :desc) }
  has_many :repos, through: :stars
  has_many :tags

  validates :name, :email, :presence => true

  def self.find_with_auth(auth_hash)
    Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]).try(:user)
  end

  def self.create_with_auth(auth_hash)
    user = new(
      name: auth_hash["info"]["nickname"],
      email: auth_hash["info"]["email"],
      avatar_url: auth_hash["info"]["image"],
    )
    user.authorizations.build provider: auth_hash["provider"], uid: auth_hash["uid"]
    user.save!
    user
  end

  def star_repo(repo, starred_at=DateTime.now, last_updated=nil)
    star = Star.find_or_initialize_by(user: self, repo: repo)
    values = {starred_at: starred_at, active: true}
    values[:last_updated] = last_updated if last_updated
    star.update(values)
  end

  def unstar_repo(repo)
    stars.where(repo: repo).update_all(active: false)
  end

  def unstar_deleted_repo(last_updated)
    stars.where('last_updated < ?', last_updated).update_all(active: false)
  end

end
