class Star < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :repo, counter_cache: :stargazers_count
  has_many :tags, through: :tags_star
end
