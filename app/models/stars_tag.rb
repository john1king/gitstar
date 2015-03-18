class StarsTag < ActiveRecord::Base
  belongs_to :tag, counter_cache: :stars_count
  belongs_to :star
end
