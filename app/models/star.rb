class Star < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :repo, counter_cache: :stargazers_count
end
