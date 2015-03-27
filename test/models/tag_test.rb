require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test 'order acitve stars' do
    assert_equal [repos(:js), repos(:python)], tags(:script).stars.map(&:repo)
  end

  test 'unstar tagged repo' do
    users(:has_stars).unstar_repo(repos(:ruby))
    assert_equal 1, tags(:has_stars).stars_count
  end

end
