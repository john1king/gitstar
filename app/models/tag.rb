class Tag < ActiveRecord::Base
  belongs_to :users
  has_many :stars, through: :tag_stars
end
