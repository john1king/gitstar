class Tag < ActiveRecord::Base
  belongs_to :users
  has_many :stars_tags
  has_many :stars, through: :stars_tags
  has_many :repos, through: :stars
end
