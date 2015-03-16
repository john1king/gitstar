class Star < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :repo, counter_cache: :stargazers_count
  has_many :stars_tags
  has_many :tags, through: :stars_tags
end
