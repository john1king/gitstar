class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :stars_tags
  has_many :stars, -> { where(active: true).order(starred_at: :desc)}, through: :stars_tags
  has_many :repos, through: :stars
end
