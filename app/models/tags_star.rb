class TagsStar < ActiveRecord::Base
  belongs_to :tag, cache_counter: :stars_count
  belongs_to :star
end
